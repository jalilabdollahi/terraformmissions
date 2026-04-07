#!/usr/bin/env python3
"""Player profile helpers."""
from __future__ import annotations
import getpass
from rich.prompt import Prompt


def prompt_player_name(current: str = "") -> str:
    default = current or getpass.getuser() or "TF Engineer"
    name = Prompt.ask("[bold bright_cyan]Enter your agent callsign[/bold bright_cyan]", default=default)
    return name.strip() or default
