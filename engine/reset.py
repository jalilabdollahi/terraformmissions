#!/usr/bin/env python3
"""Workspace management — copies broken config and initialises Terraform."""
from __future__ import annotations

import shutil
import subprocess
import sys
from pathlib import Path

from rich.console import Console

console = Console()


def _run(args: list[str], cwd: Path | None = None, check: bool = True) -> subprocess.CompletedProcess[str]:
    return subprocess.run(args, cwd=cwd, capture_output=True, text=True, check=check)


def _run_best_effort(args: list[str], cwd: Path | None = None) -> None:
    subprocess.run(args, cwd=cwd, capture_output=True, text=True, check=False)


def prepare_level(repo_root: Path, level_path: Path) -> None:
    """Destroy any existing workspace state, copy the broken config, and run terraform init."""
    workspace = repo_root / "workspace" / "current"

    # ── Destroy existing state (best-effort, non-blocking) ───────────────────
    if workspace.exists() and (workspace / "terraform.tfstate").exists():
        _run_best_effort(
            ["terraform", "destroy", "-auto-approve", "-no-color", "-input=false"],
            cwd=workspace,
        )

    # ── Wipe and recreate workspace ──────────────────────────────────────────
    if workspace.exists():
        shutil.rmtree(workspace)
    workspace.mkdir(parents=True)

    # ── Copy broken config into workspace ────────────────────────────────────
    broken_dir = level_path / "broken"
    if broken_dir.exists():
        shutil.copytree(broken_dir, workspace, dirs_exist_ok=True)
    else:
        console.print(f"[yellow]Warning: no broken/ directory found in {level_path}[/yellow]")

    # ── terraform init ────────────────────────────────────────────────────────
    result = _run(
        ["terraform", "init", "-no-color", "-input=false"],
        cwd=workspace,
        check=False,
    )
    if result.returncode != 0:
        # Init failures are valid for some levels (e.g. bad provider version)
        console.print("[grey50]Note: terraform init encountered issues — this may be part of the challenge.[/grey50]")


def main() -> int:
    if len(sys.argv) != 3:
        console.print("Usage: python3 engine/reset.py <repo_root> <level_path>")
        return 1
    repo_root = Path(sys.argv[1]).resolve()
    level_path = Path(sys.argv[2]).resolve()
    try:
        prepare_level(repo_root, level_path)
        console.print("[bright_green]✅ Level reset complete.[/bright_green]")
        return 0
    except Exception as exc:
        console.print(f"[red]Reset failed: {exc}[/red]")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
