#!/usr/bin/env python3
"""Shared runtime for TerraformMissions: environment, workspace preparation, validation.

Used by the game engine and by scripts/test_levels.py so both behave identically.

Level directory layout (see docs/LEVEL_SPEC.md):
    mission.yaml, broken/, solution/, validate.sh, [setup.sh], [solution.sh],
    hint-1..3.txt, solution-guide.md, debrief.md, common-mistakes.md
"""
from __future__ import annotations

import os
import shutil
import subprocess
import tempfile
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
VALIDATE_LIB = REPO_ROOT / "engine" / "validate_lib.sh"
# Read-only provider mirror (built by install.sh). Terraform never writes into a
# filesystem mirror, so parallel inits can't corrupt it (a shared TF_PLUGIN_CACHE_DIR can:
# on macOS an in-place overwrite of a signed provider binary makes it un-launchable).
PROVIDER_MIRROR = REPO_ROOT / ".cache" / "provider-mirror"
CLI_CONFIG = REPO_ROOT / ".cache" / "terraformrc"
MARKER_DIR = ".tm"
MARKER_FILE = "level"

SETUP_TIMEOUT = 300
VALIDATE_TIMEOUT = 300


def _mirrored_providers() -> list[str]:
    base = PROVIDER_MIRROR / "registry.terraform.io"
    if not base.is_dir():
        return []
    return sorted(f"registry.terraform.io/{ns.name}/{p.name}"
                  for ns in base.iterdir() if ns.is_dir() for p in ns.iterdir() if p.is_dir())


def cli_config() -> Path | None:
    """Write a CLI config that installs mirrored providers from the local mirror and
    everything else from the registry. Returns None if no mirror exists."""
    providers = _mirrored_providers()
    if not providers:
        return None
    inc = ", ".join(f'"{p}"' for p in providers)
    text = (
        "provider_installation {\n"
        f'  filesystem_mirror {{\n    path    = "{PROVIDER_MIRROR}"\n    include = [{inc}]\n  }}\n'
        f"  direct {{\n    exclude = [{inc}]\n  }}\n"
        "}\n"
    )
    try:
        if not CLI_CONFIG.exists() or CLI_CONFIG.read_text(encoding="utf-8") != text:
            CLI_CONFIG.parent.mkdir(parents=True, exist_ok=True)
            tmp = CLI_CONFIG.with_suffix(f".{os.getpid()}.tmp")
            tmp.write_text(text, encoding="utf-8")
            tmp.replace(CLI_CONFIG)
    except OSError:
        return None
    return CLI_CONFIG


def terraform_env(workspace: Path, level_path: Path | None = None, tmp: Path | None = None) -> dict[str, str]:
    """Environment for every terraform / validator / setup subprocess."""
    env = {
        **os.environ,
        "CHECKPOINT_DISABLE": "1",
        "WORKSPACE": str(workspace),
        "TM_LIB": str(VALIDATE_LIB),
    }
    if level_path is not None:
        env["LEVEL_PATH"] = str(level_path)
    if tmp is not None:
        env["TM_TMP"] = str(tmp)
    # Never let a player's shell override the workspace the validator inspects.
    env.pop("TF_DATA_DIR", None)
    env.pop("TF_WORKSPACE", None)
    env.pop("TF_CLI_ARGS", None)
    env.pop("TF_CLI_ARGS_plan", None)
    env.pop("TF_CLI_ARGS_apply", None)
    env.pop("TF_PLUGIN_CACHE_DIR", None)
    cfg = cli_config()
    if cfg is not None:
        env["TF_CLI_CONFIG_FILE"] = str(cfg)
    return env


def apply_runtime_env() -> None:
    """Make interactive terraform passthrough commands use the same provider mirror."""
    os.environ.setdefault("CHECKPOINT_DISABLE", "1")
    cfg = cli_config()
    if cfg is not None and "TF_CLI_CONFIG_FILE" not in os.environ:
        os.environ["TF_CLI_CONFIG_FILE"] = str(cfg)


def terraform_init(workspace: Path, env: dict[str, str] | None = None) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["terraform", "init", "-input=false", "-no-color"],
        cwd=str(workspace),
        capture_output=True,
        text=True,
        check=False,
        env=env or terraform_env(workspace),
        timeout=SETUP_TIMEOUT,
    )


def workspace_level(workspace: Path) -> str | None:
    marker = workspace / MARKER_DIR / MARKER_FILE
    try:
        return marker.read_text(encoding="utf-8").strip() or None
    except OSError:
        return None


class SetupError(RuntimeError):
    pass


def prepare_workspace(workspace: Path, level_path: Path, level_id: str | None = None) -> list[str]:
    """Wipe the workspace, copy broken/, run terraform init and the optional setup.sh.

    Returns a list of informational notes. Raises SetupError if setup.sh fails.
    """
    notes: list[str] = []
    if workspace.exists():
        shutil.rmtree(workspace)
    workspace.mkdir(parents=True)

    broken_dir = level_path / "broken"
    if broken_dir.exists():
        shutil.copytree(broken_dir, workspace, dirs_exist_ok=True)
    else:
        notes.append(f"no broken/ directory in {level_path}")

    with tempfile.TemporaryDirectory(prefix="tm-setup-") as tmp:
        env = terraform_env(workspace, level_path, Path(tmp))
        init = terraform_init(workspace, env)
        if init.returncode != 0:
            notes.append("terraform init reported errors — this may be part of the challenge.")

        setup = level_path / "setup.sh"
        if setup.exists():
            result = subprocess.run(
                ["bash", str(setup)],
                cwd=str(workspace),
                capture_output=True,
                text=True,
                check=False,
                env=env,
                timeout=SETUP_TIMEOUT,
            )
            if result.returncode != 0:
                raise SetupError(
                    f"setup.sh failed (exit {result.returncode}):\n{result.stdout}\n{result.stderr}".strip()
                )

    marker = workspace / MARKER_DIR
    marker.mkdir(exist_ok=True)
    (marker / MARKER_FILE).write_text(level_id or level_path.name, encoding="utf-8")
    return notes


def apply_solution(workspace: Path, level_path: Path) -> subprocess.CompletedProcess[str] | None:
    """Overlay solution/ onto a prepared workspace, then run solution.sh if present.

    Files that exist in broken/ but not in solution/ are deleted (the player would delete them).
    Used by the test harness only.
    """
    broken_dir = level_path / "broken"
    solution_dir = level_path / "solution"
    if broken_dir.exists():
        for f in broken_dir.rglob("*"):
            if f.is_file():
                rel = f.relative_to(broken_dir)
                if not (solution_dir / rel).exists():
                    target = workspace / rel
                    if target.is_file():
                        target.unlink()
    if solution_dir.exists():
        shutil.copytree(solution_dir, workspace, dirs_exist_ok=True)

    script = level_path / "solution.sh"
    if not script.exists():
        return None
    with tempfile.TemporaryDirectory(prefix="tm-sol-") as tmp:
        return subprocess.run(
            ["bash", str(script)],
            cwd=str(workspace),
            capture_output=True,
            text=True,
            check=False,
            env=terraform_env(workspace, level_path, Path(tmp)),
            timeout=SETUP_TIMEOUT,
        )


def run_validator(workspace: Path, level_path: Path, timeout: int = VALIDATE_TIMEOUT) -> subprocess.CompletedProcess[str]:
    """Run `terraform init` (best effort, no -upgrade) and then the level's validate.sh."""
    validator = level_path / "validate.sh"
    if not validator.exists():
        raise FileNotFoundError(f"validate.sh missing in {level_path}")
    with tempfile.TemporaryDirectory(prefix="tm-val-") as tmp:
        env = terraform_env(workspace, level_path, Path(tmp))
        try:
            terraform_init(workspace, env)
        except subprocess.TimeoutExpired:
            pass
        try:
            return subprocess.run(
                ["bash", str(validator)],
                cwd=str(workspace),
                capture_output=True,
                text=True,
                check=False,
                env=env,
                timeout=timeout,
            )
        except subprocess.TimeoutExpired as exc:
            out = exc.stdout.decode() if isinstance(exc.stdout, bytes) else (exc.stdout or "")
            return subprocess.CompletedProcess(
                exc.cmd, 124, out + f"\n❌ FAIL: validator timed out after {timeout}s", ""
            )
