#!/usr/bin/env python3
"""Scan modules/ and build levels.json registry."""
from __future__ import annotations

import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

import yaml

REPO_ROOT = Path(__file__).resolve().parent.parent


def sort_key(path: Path) -> tuple[int, str]:
    m = re.search(r"(\d+)", path.name)
    return (int(m.group(1)) if m else 9999, path.name)


def main() -> int:
    modules_dir = REPO_ROOT / "modules"
    if not modules_dir.exists():
        print("modules/ directory not found", file=sys.stderr)
        return 1

    registry: dict = {"generated_at": datetime.now(timezone.utc).isoformat(), "level_count": 0, "modules": []}

    for module_dir in sorted((p for p in modules_dir.iterdir() if p.is_dir()), key=sort_key):
        levels = []
        for level_dir in sorted((p for p in module_dir.iterdir() if p.is_dir()), key=sort_key):
            mission_file = level_dir / "mission.yaml"
            if not mission_file.exists():
                continue
            mission = yaml.safe_load(mission_file.read_text(encoding="utf-8")) or {}
            levels.append({
                "id":      f"{module_dir.name}/{level_dir.name}",
                "name":    level_dir.name,
                "path":    f"modules/{module_dir.name}/{level_dir.name}",
                "mission": mission,
            })
        if levels:
            registry["modules"].append({"name": module_dir.name, "levels": levels})
            registry["level_count"] += len(levels)

    out = REPO_ROOT / "levels.json"
    out.write_text(json.dumps(registry, indent=2), encoding="utf-8")
    print(f"✅ levels.json written — {registry['level_count']} levels across {len(registry['modules'])} modules")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
