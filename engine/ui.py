#!/usr/bin/env python3
"""Rich terminal UI for TerraformMissions."""
from __future__ import annotations

import os
import sys
import termios
import tty
from pathlib import Path

from rich.console import Console
from rich.markdown import Markdown
from rich.panel import Panel
from rich.syntax import Syntax
from rich.table import Table
from rich.text import Text

console = Console()

# ── Module metadata ───────────────────────────────────────────────────────────

MODULE_TITLES: dict[str, str] = {
    "module-1-foundations":        "HCL Foundations",
    "module-2-resource-basics":    "Resource Basics",
    "module-3-variables-outputs":  "Variables & Outputs",
    "module-4-state-management":   "State Management",
    "module-5-expressions":        "Expressions & Functions",
    "module-6-modules":            "Reusable Modules",
    "module-7-loops":              "Loops & Conditionals",
    "module-8-data-sources":       "Data Sources",
    "module-9-workspaces":         "Workspaces",
    "module-10-testing":           "Terraform Testing",
    "module-11-security":          "Security & Sensitive Data",
    "module-12-advanced-patterns": "Advanced HCL Patterns",
    "module-13-debugging":         "Debugging & Troubleshooting",
    "module-14-performance":       "Performance & Scale",
    "module-15-war-games":         "Production War Games",
}

MODULE_TOTAL_XP: dict[str, int] = {
    "module-1-foundations":        2500,
    "module-2-resource-basics":    2700,
    "module-3-variables-outputs":  2970,
    "module-4-state-management":   4200,
    "module-5-expressions":        3900,
    "module-6-modules":            4500,
    "module-7-loops":              3600,
    "module-8-data-sources":       3000,
    "module-9-workspaces":         2400,
    "module-10-testing":           4950,
    "module-11-security":          4950,
    "module-12-advanced-patterns": 5500,
    "module-13-debugging":         4950,
    "module-14-performance":       5250,
    "module-15-war-games":         8500,
}

MODULE_ICON: dict[str, str] = {
    "module-1-foundations":        "🟢",
    "module-2-resource-basics":    "🟢",
    "module-3-variables-outputs":  "🟢",
    "module-4-state-management":   "🟡",
    "module-5-expressions":        "🟡",
    "module-6-modules":            "🟡",
    "module-7-loops":              "🟡",
    "module-8-data-sources":       "🟡",
    "module-9-workspaces":         "🟡",
    "module-10-testing":           "🔴",
    "module-11-security":          "🔴",
    "module-12-advanced-patterns": "🔴",
    "module-13-debugging":         "🔴",
    "module-14-performance":       "⚫",
    "module-15-war-games":         "⚫",
}

DIFFICULTY_STARS: dict[str, str] = {
    "beginner":     "★☆☆☆",
    "intermediate": "★★☆☆",
    "advanced":     "★★★☆",
    "expert":       "★★★★",
}


def module_title(module_name: str) -> str:
    return MODULE_TITLES.get(module_name, module_name.replace("-", " ").title())


# ── Welcome screen ────────────────────────────────────────────────────────────

def show_welcome(
    player_name: str,
    total_xp: int,
    modules: list[dict],
    completed_levels: set[str],
    xp_by_module: dict[str, int],
    max_xp_by_module: dict[str, int],
    max_total_xp: int,
) -> None:
    header = Text.assemble(
        ("TerraformMissions", "bold bright_cyan"),
        ("  ✦  ", "grey50"),
        ("Learn Terraform by breaking it — then fixing it.\n", "white"),
        (f"Agent: {player_name}  •  XP: {total_xp:,} / {max_total_xp:,}", "grey70"),
    )
    console.print(Panel(header, border_style="bright_cyan", padding=(0, 2)))

    table = Table(show_header=True, header_style="bold grey70", box=None, padding=(0, 1))
    table.add_column("#", style="grey50", width=3)
    table.add_column("Module", style="white", min_width=28)
    table.add_column("Progress", style="white", min_width=14)
    table.add_column("XP", style="bright_green", justify="right", width=14)

    for i, module in enumerate(modules, 1):
        mname = module["name"]
        total_levels = len(module["levels"])
        done = sum(1 for lv in module["levels"] if lv["id"] in completed_levels)
        mxp = xp_by_module.get(mname, 0)
        max_mxp = max_xp_by_module.get(mname, MODULE_TOTAL_XP.get(mname, 1))
        icon = MODULE_ICON.get(mname, "⚪")
        title = MODULE_TITLES.get(mname, mname)
        bar_filled = int((done / total_levels) * 10) if total_levels else 0
        bar = "█" * bar_filled + "░" * (10 - bar_filled)
        prog_str = f"[bright_cyan]{bar}[/bright_cyan] {done}/{total_levels}"
        xp_str = f"{mxp:,}/{max_mxp:,}"
        table.add_row(str(i), f"{icon} {title}", prog_str, xp_str)

    console.print(table)
    console.print()


# ── Compact progress bar ──────────────────────────────────────────────────────

def show_progress_summary(
    modules: list[dict],
    completed_levels: set[str],
    xp_by_module: dict[str, int],
    total_xp: int,
    max_xp_by_module: dict[str, int],
    max_total_xp: int,
    current_module_name: str,
) -> None:
    total_done  = sum(1 for m in modules for lv in m["levels"] if lv["id"] in completed_levels)
    total_lvls  = sum(len(m["levels"]) for m in modules)
    overall_pct = int(total_done / total_lvls * 100) if total_lvls else 0
    overall_bar = "█" * (overall_pct // 5) + "░" * (20 - overall_pct // 5)

    table = Table.grid(padding=(0, 2))
    table.add_column(no_wrap=True)
    table.add_column(no_wrap=True)
    table.add_column(no_wrap=True)

    # Row 1: overall XP + total progress bar
    table.add_row(
        Text.assemble(("Total XP ", "grey50"), (f"{total_xp:,}", "bold bright_green"), (f"/{max_total_xp:,}", "grey50")),
        Text.assemble(("Overall  ", "grey50"), (overall_bar, "bright_cyan"), (f"  {total_done}/{total_lvls}", "grey70")),
        Text(""),
    )

    # One row per module — highlight current
    for m in modules:
        mname = m["name"]
        done  = sum(1 for lv in m["levels"] if lv["id"] in completed_levels)
        total = len(m["levels"])
        mxp   = xp_by_module.get(mname, 0)
        max_m = max_xp_by_module.get(mname, MODULE_TOTAL_XP.get(mname, 1))
        bar_f = int(done / total * 8) if total else 0
        bar   = "█" * bar_f + "░" * (8 - bar_f)
        icon  = MODULE_ICON.get(mname, "⚪")
        title = MODULE_TITLES.get(mname, mname)
        is_cur = mname == current_module_name

        if is_cur:
            title_text = Text.assemble((f"▶ {icon} {title}", "bold bright_cyan"))
            bar_text   = Text.assemble((bar, "bright_cyan"), (f" {done}/{total}", "bold white"))
            xp_text    = Text.assemble((f"{mxp:,}/{max_m:,}", "bright_green"))
        elif done == total and total > 0:
            title_text = Text.assemble((f"  {icon} {title}", "grey50"))
            bar_text   = Text.assemble(("████████", "grey50"), (f" {done}/{total}", "grey50"))
            xp_text    = Text.assemble((f"{mxp:,}/{max_m:,}", "grey50"))
        else:
            title_text = Text.assemble((f"  {icon} {title}", "grey70"))
            bar_text   = Text.assemble((bar, "grey70"), (f" {done}/{total}", "grey70"))
            xp_text    = Text.assemble((f"{mxp:,}/{max_m:,}", "grey70"))

        table.add_row(title_text, bar_text, xp_text)

    console.print(Panel(table, title="[bold white]📊 Progress[/bold white]", border_style="grey50", padding=(0, 1)))


# ── Mission briefing ──────────────────────────────────────────────────────────

def show_mission_briefing(
    module_num: int,
    total_modules: int,
    level_num: int,
    total_levels: int,
    mission: dict,
) -> None:
    name        = mission.get("name", "???")
    description = mission.get("description", "")
    objective   = mission.get("objective", "")
    xp          = mission.get("xp", 0)
    difficulty  = mission.get("difficulty", "beginner")
    expected    = mission.get("expected_time", "?m")
    concepts    = mission.get("concepts", [])
    stars       = DIFFICULTY_STARS.get(difficulty, "★☆☆☆")

    lines = Text.assemble(
        (f"Module {module_num}/{total_modules}  •  Mission {level_num}/{total_levels}\n", "grey50"),
        (f"{name}\n\n", "bold bright_white"),
        ("Situation:  ", "grey70"), (f"{description}\n", "white"),
        ("Objective:  ", "grey70"), (f"{objective}\n\n", "bright_yellow"),
        ("Difficulty: ", "grey70"), (f"{stars} {difficulty.title()}   ", "white"),
        ("XP: ", "grey70"), (f"+{xp}   ", "bright_green"),
        ("Est. time: ", "grey70"), (f"{expected}\n", "white"),
    )
    if concepts:
        lines.append("Concepts:   ", style="grey70")
        lines.append(", ".join(concepts) + "\n", style="bright_cyan")

    lines.append("\n")
    lines.append("📂 Open a second terminal and edit the broken files:\n", style="grey50")
    lines.append("   cd terraformissions/workspace/current\n", style="bold bright_white")
    lines.append("   Then type  ", style="grey50")
    lines.append("check", style="bold bright_cyan")
    lines.append("  here when ready.\n", style="grey50")

    console.print(Panel(lines, title="[bold bright_cyan]📋 Mission Briefing[/bold bright_cyan]", border_style="bright_cyan", padding=(0, 2)))


# ── Victory screen ────────────────────────────────────────────────────────────

def show_victory(
    module_name: str,
    level_name: str,
    xp_earned: int,
    total_xp: int,
    skipped: bool = False,
    elapsed_seconds: int | None = None,
    expected_time: str | None = None,
) -> None:
    if skipped:
        body = Text.assemble(
            ("Mission skipped — no XP awarded.\n", "grey70"),
            (f"Total XP: {total_xp:,}\n", "grey50"),
        )
        console.print(Panel(body, title="[grey70]⏭  Skipped[/grey70]", border_style="grey50"))
        return

    time_line = ""
    if elapsed_seconds is not None and expected_time:
        time_line = f"  Time: {elapsed_seconds}s  (estimated {expected_time})\n"
    elif elapsed_seconds is not None:
        time_line = f"  Time: {elapsed_seconds}s\n"

    body = Text.assemble(
        ("  Mission Complete!\n\n", "bold bright_green"),
        ("  ", ""), (f"+{xp_earned:,} XP", "bold bright_yellow"), ("  earned\n", "white"),
        ("  Total XP: ", "grey70"), (f"{total_xp:,}\n", "bright_green"),
        (time_line, "grey70"),
    )
    console.print(Panel(body, title="[bold bright_green]✅ Mission Complete[/bold bright_green]", border_style="bright_green", padding=(0, 1)))


# ── Status screen ─────────────────────────────────────────────────────────────

def show_status(
    modules: list[dict],
    completed_levels: set[str],
    xp_by_module: dict[str, int],
    total_xp: int,
    max_xp_by_module: dict[str, int],
    max_total_xp: int,
) -> None:
    table = Table(show_header=True, header_style="bold grey70", box=None, padding=(0, 1))
    table.add_column("#", style="grey50", width=3)
    table.add_column("Module", style="white", min_width=28)
    table.add_column("Missions", style="white", width=12)
    table.add_column("XP Earned", style="bright_green", justify="right", width=14)

    for i, module in enumerate(modules, 1):
        mname = module["name"]
        total_levels = len(module["levels"])
        done = sum(1 for lv in module["levels"] if lv["id"] in completed_levels)
        mxp = xp_by_module.get(mname, 0)
        max_mxp = max_xp_by_module.get(mname, MODULE_TOTAL_XP.get(mname, 1))
        icon = MODULE_ICON.get(mname, "⚪")
        title = MODULE_TITLES.get(mname, mname)
        complete_icon = "✅" if done == total_levels else ("🔄" if done > 0 else "  ")
        table.add_row(str(i), f"{complete_icon} {icon} {title}", f"{done}/{total_levels}", f"{mxp:,}/{max_mxp:,}")

    console.print(Panel(table, title="[bold white]📊 Mission Progress[/bold white]", border_style="white"))
    console.print(f"[bold]Total XP:[/bold] [bright_green]{total_xp:,}[/bright_green] / [grey50]{max_total_xp:,}[/grey50]")


# ── Help screen ───────────────────────────────────────────────────────────────

def _cmd(key: str, name: str, desc: str, newline: bool = True) -> list[tuple[str, str]]:
    """Build a single help row as a list of (text, style) tuples."""
    end = "\n" if newline else ""
    return [
        ("  ", ""),
        (key, "bold bright_cyan"),
        (" / ", "grey50"),
        (name, "bold bright_cyan"),
        ("  ", ""),
        (desc + end, "grey70"),
    ]


def show_help() -> None:
    K = "bold bright_cyan"
    S = "grey50"

    rows: list[tuple[str, str]] = [
        ("── VALIDATE ─────────────────────────────\n", S),
    ]
    for part in _cmd("1", "check",         "Run validator, award XP if correct"):
        rows.append(part)
    for part in _cmd("d", "check-dry",     "Dry-run — see result without awarding XP"):
        rows.append(part)
    for part in _cmd("w", "watch",         "Auto-validate every 5 s until pass"):
        rows.append(part)

    rows.append(("── TERRAFORM ────────────────────────────\n", S))
    for part in _cmd("p", "plan",          "Run terraform plan (informational)"):
        rows.append(part)
    for part in _cmd("v", "validate",      "Run terraform validate"):
        rows.append(part)
    for part in _cmd("i", "init",          "Re-run terraform init"):
        rows.append(part)
    rows += [("  ", ""), ("terraform", K), (" ", ""), ("<args>", "dim"),
             ("  Pass any terraform command through\n", "grey70")]

    rows.append(("── HINTS & LEARNING ─────────────────────\n", S))
    for part in _cmd("2", "hint",          "Reveal next progressive hint"):
        rows.append(part)
    for part in _cmd("3", "solution",      "Show reference solution files"):
        rows.append(part)
    for part in _cmd("4", "guide",         "Step-by-step walkthrough"):
        rows.append(part)
    for part in _cmd("5", "debrief",       "Post-mission learning debrief"):
        rows.append(part)

    rows.append(("── NAVIGATION ───────────────────────────\n", S))
    for part in _cmd("6", "reset",         "Reset level to broken state"):
        rows.append(part)
    for part in _cmd("7", "status",        "Show progress across all modules"):
        rows.append(part)
    for part in _cmd("8", "skip",          "Skip level (no XP)"):
        rows.append(part)
    for part in _cmd("9", "quit",          "Save and exit"):
        rows.append(part)
    for part in _cmd("0", "reset-progress","Wipe all progress"):
        rows.append(part)

    console.print(Panel(
        Text.assemble(*rows),
        title="[bold white]⌨  Commands[/bold white]",
        border_style="grey50",
        padding=(0, 1),
    ))


# ── Guidance (hints/walkthrough) ──────────────────────────────────────────────

def show_guidance(title: str, items: list[str]) -> None:
    body = "\n".join(f"  {item}" for item in items)
    console.print(Panel(body, title=f"[bold bright_yellow]💡 {title}[/bold bright_yellow]", border_style="bright_yellow", padding=(0, 1)))


# ── Markdown rendering ────────────────────────────────────────────────────────

def render_markdown(title: str, content: str, color: str = "white") -> None:
    console.print(Panel(Markdown(content), title=f"[bold {color}]{title}[/bold {color}]", border_style=color, padding=(0, 1)))


# ── Module completion ─────────────────────────────────────────────────────────

def show_module_completion(panel: Panel) -> None:
    console.print()
    console.print(panel)
    console.print()


# ── Post-level debrief (paginated) ────────────────────────────────────────────

class PaginatedDisplay:
    def __init__(self, content: str, title: str = "Debrief") -> None:
        self.lines = content.splitlines()
        self.title = title

    def _page_ranges(self, page_size: int) -> list[tuple[int, int]]:
        """Build page ranges without splitting code blocks."""
        ranges = []
        start = 0
        n = len(self.lines)
        in_code = False
        while start < n:
            end = min(start + page_size, n)
            # Scan lines for code block boundaries
            for i in range(start, end):
                if self.lines[i].strip().startswith("```"):
                    in_code = not in_code
            # If we're mid-code-block, extend until block closes
            if in_code and end < n:
                for i in range(end, n):
                    if self.lines[i].strip().startswith("```"):
                        end = i + 1
                        in_code = False
                        break
            ranges.append((start, min(end, n)))
            start = end
        return ranges

    @staticmethod
    def _getkey() -> str:
        fd = sys.stdin.fileno()
        old = termios.tcgetattr(fd)
        try:
            tty.setraw(fd)
            ch = os.read(fd, 1).decode("utf-8", errors="replace")
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old)
        return ch

    def show(self) -> None:
        if not self.lines:
            return
        term_h = os.get_terminal_size().lines if hasattr(os, "get_terminal_size") else 40
        page_size = max(10, term_h - 8)
        pages = self._page_ranges(page_size)
        idx = 0
        while True:
            start, end = pages[idx]
            chunk = "\n".join(self.lines[start:end])
            is_last = idx == len(pages) - 1
            page_label = f"  ({idx + 1}/{len(pages)})" if len(pages) > 1 else ""

            console.print(Panel(
                Markdown(chunk),
                title=f"[bold white]{self.title}[/bold white][grey50]{page_label}[/grey50]",
                border_style="white",
                padding=(0, 1),
            ))

            if is_last:
                nav = "[grey50]Press Enter to continue  q=skip[/grey50]"
            else:
                nav = "[grey50]Enter=next  b=prev  g=top  q=skip[/grey50]"

            console.print(nav, end="\r")
            key = self._getkey()
            console.print(" " * 50, end="\r")

            if key in ("q", "Q"):
                break
            elif key == "b":
                idx = max(idx - 1, 0)
            elif key == "g":
                idx = 0
            else:
                # Space / Enter / any other key
                if is_last:
                    break
                idx += 1


def show_post_level_debrief(
    level_path: Path,
    elapsed_seconds: int | None = None,
    expected_time: str | None = None,
) -> None:
    debrief_path  = level_path / "debrief.md"
    mistakes_path = level_path / "common-mistakes.md"

    parts: list[tuple[str, str]] = []
    if debrief_path.exists():
        parts.append(("📖 Debrief", debrief_path.read_text(encoding="utf-8")))
    if mistakes_path.exists():
        parts.append(("⚠️  Common Mistakes", mistakes_path.read_text(encoding="utf-8")))

    for title, content in parts:
        PaginatedDisplay(content, title).show()
