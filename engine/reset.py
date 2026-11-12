#!/usr/bin/env python3
"""Workspace management — restores a level's broken config into workspace/current."""
from __future__ import annotations

import sys
from pathlib import Path

from rich.console import Console

try:
    from engine.runtime import SetupError, prepare_workspace
except ModuleNotFoundError:  # running as a plain script
    sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
    from engine.runtime import SetupError, prepare_workspace

console = Console()


def prepare_level(repo_root: Path, level_path: Path, level_id: str | None = None) -> bool:
    """Wipe workspace/current, copy broken/, run terraform init and the level's setup.sh.

    Returns False (and prints the error) if the level's setup step failed.
    """
    workspace = repo_root / "workspace" / "current"
    console.print("[grey50]⟳  Preparing mission workspace...[/grey50]", end="\r")
    try:
        notes = prepare_workspace(workspace, level_path, level_id)
    except SetupError as exc:
        console.print(f"[red]Level setup failed — please report this level.\n{exc}[/red]")
        return False
    console.print(" " * 40, end="\r")
    for note in notes:
        console.print(f"[grey50]Note: {note}[/grey50]")
    return True


def main() -> int:
    if len(sys.argv) != 3:
        console.print("Usage: python3 engine/reset.py <repo_root> <level_path>")
        return 1
    repo_root = Path(sys.argv[1]).resolve()
    level_path = Path(sys.argv[2]).resolve()
    if prepare_level(repo_root, level_path):
        console.print("[bright_green]✅ Level reset complete.[/bright_green]")
        return 0
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
