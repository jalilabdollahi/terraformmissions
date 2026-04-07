#!/usr/bin/env python3
"""Module completion certificate generator."""
from __future__ import annotations

from datetime import date
from pathlib import Path

from rich.panel import Panel
from rich.text import Text


def generate_certificate(player_name: str, module_name: str, module_title: str, xp_earned: int) -> str:
    today = date.today().strftime("%B %d, %Y")
    return f"""# TerraformMissions — Module Certificate

**Agent:** {player_name}
**Module:** {module_title}
**Completed:** {today}
**XP Earned:** {xp_earned:,}

This certifies that the above agent has successfully completed all missions
in the **{module_title}** module of TerraformMissions, demonstrating proficiency
in real-world Terraform skills under simulated production conditions.

*Issued by TerraformMissions Mission Control*
"""


def render_certificate_panel(player_name: str, module_title: str, module_name: str, xp_earned: int) -> Panel:
    today = date.today().strftime("%B %d, %Y")
    body = Text.assemble(
        ("\n  ★  MODULE COMPLETE  ★\n\n", "bold bright_yellow"),
        ("  Agent:    ", "grey70"), (f"{player_name}\n", "bold white"),
        ("  Module:   ", "grey70"), (f"{module_title}\n", "bold bright_cyan"),
        ("  Date:     ", "grey70"), (f"{today}\n", "white"),
        ("  XP:       ", "grey70"), (f"+{xp_earned:,} XP\n", "bold bright_green"),
        ("\n  All missions in this module complete.\n", "grey70"),
        ("  Certificate saved to certificates/\n", "grey50"),
    )
    return Panel(body, title="[bold bright_yellow]🏅 Certificate of Completion[/bold bright_yellow]", border_style="bright_yellow", padding=(0, 2))


def save_certificate(repo_root: Path, module_name: str, certificate_text: str) -> None:
    certs_dir = repo_root / "certificates"
    certs_dir.mkdir(exist_ok=True)
    (certs_dir / f"{module_name}-certificate.md").write_text(certificate_text, encoding="utf-8")
