#!/usr/bin/env python3
"""TerraformMissions — main game loop."""
from __future__ import annotations

import json
import os
import re
import readline  # noqa: F401 — enables arrow-keys / history in Prompt.ask()
import shlex
import subprocess
import sys
import time
from pathlib import Path

import yaml
from rich.console import Console
from rich.panel import Panel
from rich.prompt import Prompt
from rich.syntax import Syntax
from rich.text import Text

try:
    from engine.certificate import generate_certificate, render_certificate_panel, save_certificate
    from engine.player import prompt_player_name
    from engine.reset import prepare_level
    from engine.runtime import apply_runtime_env, run_validator as _runtime_validator, terraform_init, workspace_level
    from engine.ui import (
        console,
        module_title,
        render_markdown,
        show_guidance,
        show_help,
        show_mission_briefing,
        show_module_completion,
        show_post_level_debrief,
        show_progress_summary,
        show_status,
        show_victory,
        show_welcome,
    )
except ModuleNotFoundError:
    from certificate import generate_certificate, render_certificate_panel, save_certificate
    from player import prompt_player_name
    from reset import prepare_level
    from runtime import apply_runtime_env, run_validator as _runtime_validator, terraform_init, workspace_level
    from ui import (
        console,
        module_title,
        render_markdown,
        show_guidance,
        show_help,
        show_mission_briefing,
        show_module_completion,
        show_post_level_debrief,
        show_progress_summary,
        show_status,
        show_victory,
        show_welcome,
    )

REPO_ROOT       = Path(__file__).resolve().parent.parent
PROGRESS_FILE   = REPO_ROOT / "progress.json"
LEVELS_REGISTRY = REPO_ROOT / "levels.json"
WORKSPACE       = REPO_ROOT / "workspace" / "current"


# ── Terraform health check ────────────────────────────────────────────────────

def terraform_install_hint() -> tuple[str, str]:
    if sys.platform.startswith("linux"):
        return (
            "Install Terraform, then re-run ./install.sh\n\n"
            "Ubuntu/Debian:\n"
            "  sudo apt-get update && sudo apt-get install -y wget gpg software-properties-common\n"
            "  wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | \\\n"
            "    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null\n"
            "  echo \"deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(. /etc/os-release && echo \\\"$VERSION_CODENAME\\\") main\" | \\\n"
            "    sudo tee /etc/apt/sources.list.d/hashicorp.list\n"
            "  sudo apt-get update && sudo apt-get install -y terraform",
            "bright_cyan",
        )
    if sys.platform == "darwin":
        return (
            "Install Terraform with:\n"
            "  brew tap hashicorp/tap && brew install hashicorp/tap/terraform\n"
            "Then re-run ./install.sh",
            "bright_cyan",
        )
    return (
        "Install from:\n"
        "  https://developer.hashicorp.com/terraform/downloads\n"
        "Then re-run ./install.sh",
        "bright_cyan",
    )


def check_terraform_available() -> bool:
    try:
        result = subprocess.run(["terraform", "version"], capture_output=True, text=True, check=False, timeout=30)
    except (FileNotFoundError, subprocess.TimeoutExpired):
        return False
    return result.returncode == 0


# ── Progress ──────────────────────────────────────────────────────────────────

def load_progress() -> dict:
    if not PROGRESS_FILE.exists():
        return {
            "player_name": "",
            "total_xp": 0,
            "completed_levels": [],
            "current_module": "",
            "current_level": "",
            "module_certificates": [],
            "time_per_level": {},
            "level_start_time": None,
        }
    data = json.loads(PROGRESS_FILE.read_text(encoding="utf-8"))
    data.setdefault("time_per_level", {})
    data.setdefault("level_start_time", None)
    return data


def save_progress(progress: dict) -> None:
    PROGRESS_FILE.write_text(json.dumps(progress, indent=2), encoding="utf-8")


# ── Module / level loading ────────────────────────────────────────────────────

def _sort_key(path: Path) -> tuple[int, str]:
    m = re.search(r"(\d+)", path.name)
    return (int(m.group(1)) if m else 9999, path.name)


def load_modules() -> list[dict]:
    # Fast path: pre-built registry
    if LEVELS_REGISTRY.exists():
        try:
            registry = json.loads(LEVELS_REGISTRY.read_text(encoding="utf-8"))
            modules = []
            for w in registry.get("modules", []):
                levels = []
                for lv in w.get("levels", []):
                    level_path = REPO_ROOT / lv["path"]
                    if level_path.exists():
                        levels.append({
                            "id":      lv["id"],
                            "name":    lv["name"],
                            "path":    level_path,
                            "mission": lv["mission"],
                        })
                if levels:
                    modules.append({"name": w["name"], "path": REPO_ROOT / "modules" / w["name"], "levels": levels})
            if modules:
                return modules
        except Exception:
            pass

    # Fallback: directory scan
    modules = []
    modules_dir = REPO_ROOT / "modules"
    for module_dir in sorted((p for p in modules_dir.iterdir() if p.is_dir()), key=_sort_key):
        levels = []
        for level_dir in sorted((p for p in module_dir.iterdir() if p.is_dir()), key=_sort_key):
            mission_file = level_dir / "mission.yaml"
            if not mission_file.exists():
                continue
            mission = yaml.safe_load(mission_file.read_text(encoding="utf-8")) or {}
            levels.append({"id": f"{module_dir.name}/{level_dir.name}", "name": level_dir.name, "path": level_dir, "mission": mission})
        if levels:
            modules.append({"name": module_dir.name, "path": module_dir, "levels": levels})
    return modules


def compute_max_xp_by_module(modules: list[dict]) -> dict[str, int]:
    return {m["name"]: sum(int(lv["mission"].get("xp", 0)) for lv in m["levels"]) for m in modules}


def build_module_xp(modules: list[dict], completed: set[str]) -> dict[str, int]:
    return {m["name"]: sum(int(lv["mission"].get("xp", 0)) for lv in m["levels"] if lv["id"] in completed) for m in modules}


def current_position(modules: list[dict], progress: dict) -> tuple[int, int]:
    cm = progress.get("current_module")
    cl = progress.get("current_level")
    for mi, module in enumerate(modules):
        if module["name"] != cm:
            continue
        for li, level in enumerate(module["levels"]):
            if level["name"] == cl:
                return mi, li
    return 0, 0


def advance(modules: list[dict], mi: int, li: int) -> tuple[int | None, int | None]:
    if li + 1 < len(modules[mi]["levels"]):
        return mi, li + 1
    if mi + 1 < len(modules):
        return mi + 1, 0
    return None, None


# ── Validator ─────────────────────────────────────────────────────────────────

def _auto_init() -> None:
    """Run terraform init silently (no -upgrade, shared plugin cache) so the player never has to."""
    console.print("[grey50]⟳  terraform init...[/grey50]", end="\r")
    try:
        terraform_init(WORKSPACE)
    except subprocess.TimeoutExpired:
        pass
    console.print(" " * 30, end="\r")  # clear the line


def run_validator(level_path: Path) -> subprocess.CompletedProcess[str]:
    console.print("[grey50]⟳  validating...[/grey50]", end="\r")
    result = _runtime_validator(WORKSPACE, level_path)
    console.print(" " * 30, end="\r")
    return result


# ── Terraform passthrough ─────────────────────────────────────────────────────

def run_terraform(args_str: str) -> None:
    args = shlex.split(f"terraform {args_str}".strip())
    result = subprocess.run(args, cwd=str(WORKSPACE), capture_output=False, text=True, check=False)
    if result.returncode not in (0, 2):
        console.print(f"[grey50]Exit code: {result.returncode}[/grey50]")


def run_terraform_info(cmd: str) -> None:
    """Run a terraform command and stream output to the console."""
    result = subprocess.run(
        shlex.split(f"terraform {cmd} -no-color"),
        cwd=str(WORKSPACE),
        capture_output=True,
        text=True,
        check=False,
    )
    if result.stdout:
        console.print(result.stdout.rstrip())
    if result.stderr:
        style = "red" if result.returncode not in (0, 2) else "yellow"
        console.print(f"[{style}]{result.stderr.rstrip()}[/{style}]")


# ── Guide / solution display ──────────────────────────────────────────────────

def show_solution(level_path: Path) -> None:
    """Show the reference solution files and, if any, the commands the player must run."""
    solution_dir = level_path / "solution"
    if not solution_dir.exists():
        console.print("[yellow]No solution available for this level.[/yellow]")
        return

    tf_files = sorted(p for p in solution_dir.rglob("*") if p.is_file() and ".terraform" not in p.parts)
    if not tf_files and not (level_path / "solution.sh").exists():
        console.print("[yellow]No solution files found.[/yellow]")
        return

    for f in tf_files:
        rel = f.relative_to(solution_dir)
        syntax = Syntax(f.read_text(encoding="utf-8"), _lexer_for(f), theme="ansi_dark", line_numbers=True)
        console.print(Panel(syntax, title=f"[bold bright_yellow]solution/{rel}[/bold bright_yellow]", border_style="bright_yellow"))

    script = level_path / "solution.sh"
    if script.exists():
        lines = [ln for ln in script.read_text(encoding="utf-8").splitlines()
                 if ln.strip() and not ln.startswith("#!") and "TM_LIB" not in ln]
        syntax = Syntax("\n".join(lines), "bash", theme="ansi_dark")
        console.print(Panel(syntax, title="[bold bright_yellow]Commands to run in the workspace[/bold bright_yellow]", border_style="bright_yellow"))


def _lexer_for(path: Path) -> str:
    if path.suffix in {".sh"}:
        return "bash"
    if path.suffix in {".json"}:
        return "json"
    if path.suffix in {".yaml", ".yml"}:
        return "yaml"
    if path.suffix in {".py"}:
        return "python"
    return "hcl"


def show_guide(level_path: Path) -> None:
    guide_path = level_path / "solution-guide.md"
    if guide_path.exists():
        render_markdown("Walkthrough", guide_path.read_text(encoding="utf-8"), "bright_yellow")
        return
    show_solution(level_path)


def show_debrief(level_path: Path) -> None:
    if not (level_path / "debrief.md").exists() and not (level_path / "common-mistakes.md").exists():
        console.print("[yellow]No debrief available for this level.[/yellow]")
        return
    show_post_level_debrief(level_path)


# ── XP / completion ───────────────────────────────────────────────────────────

def award_module_certificate(progress: dict, modules: list[dict], mi: int, completed: set[str]) -> None:
    module = modules[mi]
    if module["name"] in progress.get("module_certificates", []):
        return
    module_ids = {lv["id"] for lv in module["levels"]}
    if not module_ids.issubset(completed):
        return
    mxp = sum(int(lv["mission"].get("xp", 0)) for lv in module["levels"] if lv["id"] in completed)
    w_title = module_title(module["name"])
    cert_text = generate_certificate(progress["player_name"], module["name"], w_title, mxp)
    save_certificate(REPO_ROOT, module["name"], cert_text)
    panel = render_certificate_panel(progress["player_name"], w_title, module["name"], mxp)
    progress.setdefault("module_certificates", []).append(module["name"])
    save_progress(progress)
    show_module_completion(panel)


def complete_level(progress: dict, modules: list[dict], mi: int, li: int, award_xp: bool) -> bool:
    completed = set(progress.get("completed_levels", []))
    level = modules[mi]["levels"][li]
    level_id = level["id"]
    xp = int(level["mission"].get("xp", 0)) if award_xp and level_id not in completed else 0

    elapsed: int | None = None
    start_ts = progress.get("level_start_time")
    if start_ts is not None:
        elapsed = max(0, int(time.time() - start_ts))
        progress.setdefault("time_per_level", {})[level_id] = elapsed
    progress["level_start_time"] = None

    completed.add(level_id)
    progress["completed_levels"] = sorted(completed)
    progress["total_xp"] = int(progress.get("total_xp", 0)) + xp
    save_progress(progress)

    console.clear()
    show_victory(
        modules[mi]["name"],
        level["mission"].get("name", level["name"]),
        xp,
        progress["total_xp"],
        skipped=not award_xp,
        elapsed_seconds=elapsed,
        expected_time=level["mission"].get("expected_time"),
    )

    if award_xp:
        console.print("\n[grey50]Press Enter to read the debrief...[/grey50]", end="")
        input()
        console.clear()
        show_post_level_debrief(level["path"], elapsed_seconds=elapsed, expected_time=level["mission"].get("expected_time"))

    award_module_certificate(progress, modules, mi, completed)

    next_mi, next_li = advance(modules, mi, li)
    if next_mi is None:
        console.print("[bold bright_green]🎉 All missions complete. Mission Control salutes you.[/bold bright_green]")
        return False

    progress["current_module"] = modules[next_mi]["name"]
    progress["current_level"]  = modules[next_mi]["levels"][next_li]["name"]
    save_progress(progress)

    console.print("\n[grey50]Press Enter to start the next mission...[/grey50]", end="")
    input()
    console.clear()

    nxt = modules[next_mi]["levels"][next_li]
    prepare_level(REPO_ROOT, nxt["path"], nxt["id"])
    return True


# ── Watch mode ────────────────────────────────────────────────────────────────

def watch_mode(level_path: Path) -> bool:
    interval = 5
    console.print(Panel(
        Text.assemble(
            ("Watch mode active — ", "bright_cyan"),
            ("validator runs every 5s", "white"),
            ("  •  ", "grey50"),
            ("Ctrl+C to cancel", "grey70"),
        ),
        border_style="bright_cyan", padding=(0, 1),
    ))
    attempt = 0
    try:
        while True:
            attempt += 1
            result = run_validator(level_path)
            if result.stdout:
                console.print(result.stdout.rstrip())
            if result.returncode == 0:
                console.print(f"[bold bright_green]✅ Passed on attempt {attempt}[/bold bright_green]")
                return True
            for remaining in range(interval, 0, -1):
                console.print(f"\r[grey70]  ↺ Attempt {attempt} failed — rechecking in {remaining}s...[/grey70]", end="")
                time.sleep(1)
            console.print()
    except KeyboardInterrupt:
        console.print("\n[yellow]Watch mode cancelled.[/yellow]")
        return False


# ── Number → command map ──────────────────────────────────────────────────────

_NUMBER_CMDS: dict[str, str] = {
    "1": "check",
    "d": "check-dry",
    "w": "watch",
    "2": "hint",
    "3": "solution",
    "4": "guide",
    "5": "debrief",
    "p": "plan",
    "v": "validate",
    "i": "init",
    "6": "reset",
    "7": "status",
    "8": "skip",
    "9": "quit",
    "0": "reset-progress",
}

_TERRAFORM_VERBS = {
    "init", "plan", "apply", "destroy", "validate", "fmt", "show",
    "state", "output", "workspace", "import", "refresh", "force-unlock",
    "providers", "graph", "console", "get", "version",
}


# ── Main game loop ────────────────────────────────────────────────────────────

def game_loop() -> int:
    apply_runtime_env()
    # Terraform availability check
    console.print("[grey70]Checking Terraform...[/grey70]", end="\r")
    if not check_terraform_available():
        install_hint, install_hint_style = terraform_install_hint()
        console.print(Panel(
            Text.assemble(
                ("Terraform not found on PATH.\n\n", "bold red"),
                (install_hint, install_hint_style),
            ),
            title="[bold red]Terraform Not Found[/bold red]",
            border_style="red",
        ))
        return 1
    console.print(" " * 50, end="\r")

    modules  = load_modules()
    progress = load_progress()

    if not modules:
        console.print(Panel(
            Text.assemble(
                ("No levels found.\n\n", "bold red"),
                ("Rebuild the level registry:\n", "white"),
                ("  python3 scripts/generate_registry.py\n", "bright_cyan"),
                ("Then re-run ./play.sh", "grey70"),
            ),
            title="[bold red]No Levels Found[/bold red]",
            border_style="red",
        ))
        return 1

    # Ensure player name
    if not progress.get("player_name"):
        progress["player_name"] = prompt_player_name(progress.get("player_name", ""))
        save_progress(progress)

    # Ensure current position
    if not modules:
        console.print("[red]No implemented levels found.[/red]")
        return 1
    mi, li = current_position(modules, progress)
    progress["current_module"] = modules[mi]["name"]
    progress["current_level"]  = modules[mi]["levels"][li]["name"]
    save_progress(progress)

    completed   = set(progress.get("completed_levels", []))
    xp_by_mod   = build_module_xp(modules, completed)
    max_xp_mod  = compute_max_xp_by_module(modules)
    max_total   = sum(max_xp_mod.values())

    show_welcome(progress["player_name"], int(progress.get("total_xp", 0)), modules, completed, xp_by_mod, max_xp_mod, max_total)

    mi, li = current_position(modules, progress)
    current_level = modules[mi]["levels"][li]
    if workspace_level(WORKSPACE) == current_level["id"]:
        console.print("[grey50]Resuming your workspace for this mission (type [bold]reset[/bold] to restore the broken files).[/grey50]")
    else:
        prepare_level(REPO_ROOT, current_level["path"], current_level["id"])

    if not progress.get("level_start_time"):
        progress["level_start_time"] = time.time()
        save_progress(progress)

    hint_index = 0

    while True:
        modules  = load_modules()
        progress = load_progress()
        mi, li   = current_position(modules, progress)
        current_level = modules[mi]["levels"][li]
        mission = current_level["mission"]

        console.clear()
        completed   = set(progress.get("completed_levels", []))
        xp_by_mod   = build_module_xp(modules, completed)
        max_xp_mod  = compute_max_xp_by_module(modules)
        max_total   = sum(max_xp_mod.values())
        show_progress_summary(modules, completed, xp_by_mod, int(progress.get("total_xp", 0)), max_xp_mod, max_total, modules[mi]["name"])
        show_mission_briefing(mi + 1, len(modules), li + 1, len(modules[mi]["levels"]), mission, WORKSPACE)
        show_help()

        while True:
            command = Prompt.ask("[bold bright_cyan]mission-control[/bold bright_cyan]", default="check").strip()
            if not command:
                continue

            command = _NUMBER_CMDS.get(command, command)

            # ── Quit ──────────────────────────────────────────────────────────
            if command in {"quit", "exit"}:
                save_progress(progress)
                return 0

            # ── Help ──────────────────────────────────────────────────────────
            if command in {"help", "?"}:
                show_help()
                continue

            # ── Status ────────────────────────────────────────────────────────
            if command == "status":
                completed   = set(progress.get("completed_levels", []))
                xp_by_mod   = build_module_xp(modules, completed)
                max_xp_mod  = compute_max_xp_by_module(modules)
                max_total   = sum(max_xp_mod.values())
                show_status(modules, completed, xp_by_mod, int(progress.get("total_xp", 0)), max_xp_mod, max_total)
                continue

            # ── Hints ─────────────────────────────────────────────────────────
            if command == "hint":
                next_path = current_level["path"] / f"hint-{hint_index + 1}.txt"
                if next_path.exists():
                    hint_index += 1
                    show_guidance(f"Hint {hint_index}", [next_path.read_text(encoding="utf-8").strip()])
                elif hint_index:
                    console.print("[yellow]No more hints — try [bold]guide[/bold] for the full walkthrough.[/yellow]")
                    last = current_level["path"] / f"hint-{hint_index}.txt"
                    show_guidance(f"Hint {hint_index}", [last.read_text(encoding="utf-8").strip()])
                else:
                    console.print("[yellow]No hints for this mission.[/yellow]")
                continue

            # ── Solution ──────────────────────────────────────────────────────
            if command == "solution":
                show_solution(current_level["path"])
                continue

            # ── Guide ─────────────────────────────────────────────────────────
            if command == "guide":
                show_guide(current_level["path"])
                continue

            # ── Debrief ───────────────────────────────────────────────────────
            if command == "debrief":
                show_debrief(current_level["path"])
                continue

            # ── Terraform: plan ───────────────────────────────────────────────
            if command == "plan":
                _auto_init()
                run_terraform_info("plan")
                continue

            # ── Terraform: validate ───────────────────────────────────────────
            if command == "validate":
                _auto_init()
                run_terraform_info("validate")
                continue

            # ── Terraform: init ───────────────────────────────────────────────
            if command == "init":
                console.print("[grey70]Running terraform init...[/grey70]")
                run_terraform_info("init -input=false -upgrade")
                continue

            # ── Terraform passthrough ─────────────────────────────────────────
            if command.startswith("terraform "):
                run_terraform(command[len("terraform "):])
                continue
            if command == "terraform":
                console.print("[yellow]Usage: terraform <args>  (e.g.  terraform state list)[/yellow]")
                continue
            # Auto-prefix bare terraform verbs
            first = command.split()[0] if command.split() else ""
            if first in _TERRAFORM_VERBS:
                run_terraform(command)
                continue

            # ── Check ─────────────────────────────────────────────────────────
            if command == "check":
                result = run_validator(current_level["path"])
                if result.stdout:
                    console.print(result.stdout.rstrip())
                if result.stderr:
                    console.print(f"[yellow]{result.stderr.rstrip()}[/yellow]")
                if result.returncode == 0:
                    if complete_level(progress, modules, mi, li, award_xp=True):
                        progress = load_progress()
                        progress["level_start_time"] = time.time()
                        save_progress(progress)
                        hint_index = 0
                        break
                    return 0
                continue

            # ── Check-dry ─────────────────────────────────────────────────────
            if command == "check-dry":
                result = run_validator(current_level["path"])
                console.print("[bold grey70]── Dry Run (no XP) ──[/bold grey70]")
                if result.stdout:
                    console.print(result.stdout.rstrip())
                if result.stderr:
                    console.print(f"[yellow]{result.stderr.rstrip()}[/yellow]")
                verdict = "[bright_green]WOULD PASS[/bright_green]" if result.returncode == 0 else "[red]WOULD FAIL[/red]"
                console.print(f"[grey70]Exit code {result.returncode} → {verdict}[/grey70]")
                continue

            # ── Watch ─────────────────────────────────────────────────────────
            if command == "watch":
                passed = watch_mode(current_level["path"])
                if passed:
                    if complete_level(progress, modules, mi, li, award_xp=True):
                        progress = load_progress()
                        progress["level_start_time"] = time.time()
                        save_progress(progress)
                        hint_index = 0
                        break
                    return 0
                continue

            # ── Reset ─────────────────────────────────────────────────────────
            if command == "reset":
                prepare_level(REPO_ROOT, current_level["path"], current_level["id"])
                hint_index = 0
                progress["level_start_time"] = time.time()
                save_progress(progress)
                console.print("[green]Level reset — workspace restored to broken state.[/green]")
                continue

            # ── Skip ──────────────────────────────────────────────────────────
            if command == "skip":
                if complete_level(progress, modules, mi, li, award_xp=False):
                    progress = load_progress()
                    progress["level_start_time"] = time.time()
                    save_progress(progress)
                    hint_index = 0
                    break
                return 0

            # ── Reset progress ────────────────────────────────────────────────
            if command == "reset-progress":
                confirm = Prompt.ask(
                    "[bold bright_red]⚠️  Wipe ALL progress? [y/N][/bold bright_red]",
                    default="N",
                ).strip().lower()
                if confirm == "y":
                    player = progress.get("player_name", "")
                    progress = {
                        "player_name": player, "total_xp": 0, "completed_levels": [],
                        "current_module": "", "current_level": "", "module_certificates": [],
                        "time_per_level": {}, "level_start_time": time.time(),
                    }
                    first = modules[0]["levels"][0]
                    progress["current_module"] = modules[0]["name"]
                    progress["current_level"] = first["name"]
                    save_progress(progress)
                    prepare_level(REPO_ROOT, first["path"], first["id"])
                    console.print("[bright_green]✅ Progress reset. Starting from Module 1.[/bright_green]")
                    hint_index = 0
                    break
                else:
                    console.print("[grey70]Cancelled.[/grey70]")
                continue

            console.print("[yellow]Unknown command. Type 'help' for available actions.[/yellow]")


if __name__ == "__main__":
    try:
        raise SystemExit(game_loop())
    except KeyboardInterrupt:
        save_progress(load_progress())
        sys.exit(130)
