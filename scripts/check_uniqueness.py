#!/usr/bin/env python3
"""Detect levels that are too similar to each other.

Compares every pair of levels (across ALL modules) on:
  - mission name / objective (exact duplicates)
  - broken/ config      (token 4-gram Jaccard similarity, comments stripped)
  - validate.sh         (token 4-gram Jaccard, library calls normalised)
  - debrief.md          (word 5-gram Jaccard)

Usage:
  python3 scripts/check_uniqueness.py                      # all levels
  python3 scripts/check_uniqueness.py --focus module-3-variables-outputs
        # only report pairs where at least one level is in that module
  python3 scripts/check_uniqueness.py --threshold 0.45
"""
from __future__ import annotations

import argparse
import itertools
import re
import sys
from pathlib import Path

import yaml

REPO_ROOT = Path(__file__).resolve().parent.parent
MODULES_DIR = REPO_ROOT / "modules"

TOKEN_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_]*|\d+|\S")


def strip_comments(text: str) -> str:
    text = re.sub(r"/\*.*?\*/", " ", text, flags=re.S)
    return "\n".join(re.split(r"(?<!:)//|#", ln, maxsplit=1)[0] for ln in text.splitlines())


def shingles(tokens: list[str], n: int) -> set[tuple[str, ...]]:
    if len(tokens) < n:
        return {tuple(tokens)} if tokens else set()
    return {tuple(tokens[i:i + n]) for i in range(len(tokens) - n + 1)}


def jaccard(a: set, b: set) -> float:
    if not a or not b:
        return 0.0
    return len(a & b) / len(a | b)


def config_text(d: Path) -> str:
    if not d.is_dir():
        return ""
    parts = []
    for f in sorted(d.rglob("*")):
        if f.is_file() and f.name != "terraform.tf" and ".terraform" not in f.parts:
            try:
                parts.append(f.read_text(encoding="utf-8"))
            except UnicodeDecodeError:
                pass
    return strip_comments("\n".join(parts))


def load(level: Path) -> dict:
    mission = yaml.safe_load((level / "mission.yaml").read_text(encoding="utf-8")) or {}
    broken = TOKEN_RE.findall(config_text(level / "broken"))
    val = (level / "validate.sh").read_text(encoding="utf-8") if (level / "validate.sh").exists() else ""
    val = re.sub(r"^#.*$", "", val, flags=re.M)
    deb = (level / "debrief.md").read_text(encoding="utf-8").lower() if (level / "debrief.md").exists() else ""
    return {
        "id": f"{level.parent.name}/{level.name}",
        "module": level.parent.name,
        "name": str(mission.get("name", "")).strip().lower(),
        "objective": str(mission.get("objective", "")).strip().lower(),
        "broken": shingles(broken, 4),
        "validate": shingles(TOKEN_RE.findall(val), 4),
        "debrief": shingles(re.findall(r"[a-z0-9_]+", deb), 5),
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--focus", help="only report pairs touching this module")
    ap.add_argument("--threshold", type=float, default=0.5, help="broken/ similarity threshold")
    args = ap.parse_args()

    levels = [p for m in MODULES_DIR.iterdir() if m.is_dir() for p in m.iterdir() if (p / "mission.yaml").exists()]
    data = [load(p) for p in levels]
    problems = 0

    def relevant(a: dict, b: dict) -> bool:
        return not args.focus or args.focus in (a["module"], b["module"])

    seen_names: dict[str, str] = {}
    seen_obj: dict[str, str] = {}
    for d in data:
        for key, seen in (("name", seen_names), ("objective", seen_obj)):
            if d[key] in seen and (not args.focus or args.focus in (d["module"], seen[d[key]].split("/")[0])):
                print(f"DUPLICATE {key}: {d['id']}  ==  {seen[d[key]]}")
                problems += 1
            seen.setdefault(d[key], d["id"])

    pairs = []
    for a, b in itertools.combinations(data, 2):
        if not relevant(a, b):
            continue
        sb = jaccard(a["broken"], b["broken"])
        sv = jaccard(a["validate"], b["validate"])
        sd = jaccard(a["debrief"], b["debrief"])
        if sb >= args.threshold or sv >= 0.8 or sd >= 0.35:
            pairs.append((max(sb, sv, sd), sb, sv, sd, a["id"], b["id"]))
    for _, sb, sv, sd, x, y in sorted(pairs, reverse=True):
        print(f"SIMILAR broken={sb:.2f} validate={sv:.2f} debrief={sd:.2f}\n   {x}\n   {y}")
        problems += 1

    print(f"\n{len(data)} levels checked — {problems} similarity problem(s)")
    return 1 if problems else 0


if __name__ == "__main__":
    raise SystemExit(main())
