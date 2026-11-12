#!/usr/bin/env python3
"""TerraformMissions level test harness.

For every selected level it checks, in isolated temp workspaces (safe to run in parallel):

  1. structure  — required files exist, mission.yaml is complete, validators source $TM_LIB
  2. broken     — prepare workspace (broken/ + init + setup.sh) → validate.sh must FAIL (exit 1)
  3. solution   — prepare, overlay solution/ (+ run solution.sh) → validate.sh must PASS (exit 0),
                  and must PASS again on a second run (players often press check twice)
  4. gutted     — prepare, delete every *.tf/*.tftest.hcl except terraform.tf → validate.sh must FAIL
                  (proves the validator checks real behaviour, not just "terraform validate")

Usage:
  python3 scripts/test_levels.py module-1-foundations            # whole module
  python3 scripts/test_levels.py module-1-foundations/level-3-x  # one level
  python3 scripts/test_levels.py --all -j 4
  python3 scripts/test_levels.py module-2-resource-basics --keep  # keep temp dirs for debugging
"""
from __future__ import annotations

import argparse
import re
import shutil
import sys
import tempfile
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass, field
from pathlib import Path

import yaml

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from engine.runtime import SetupError, apply_solution, prepare_workspace, run_validator  # noqa: E402

REPO_ROOT = Path(__file__).resolve().parent.parent
MODULES_DIR = REPO_ROOT / "modules"

REQUIRED_FILES = [
    "mission.yaml", "validate.sh", "hint-1.txt", "hint-2.txt", "hint-3.txt",
    "solution-guide.md", "debrief.md", "common-mistakes.md",
]
REQUIRED_MISSION_KEYS = ["name", "description", "objective", "xp", "difficulty", "expected_time", "concepts", "module", "level"]
DIFFICULTIES = {"beginner", "intermediate", "advanced", "expert"}


@dataclass
class Result:
    level: str
    errors: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)
    seconds: float = 0.0

    @property
    def ok(self) -> bool:
        return not self.errors


def sort_key(path: Path) -> tuple[int, str]:
    m = re.search(r"(\d+)", path.name)
    return (int(m.group(1)) if m else 9999, path.name)


def select_levels(targets: list[str], all_levels: bool) -> list[Path]:
    if all_levels:
        targets = [p.name for p in sorted(MODULES_DIR.iterdir(), key=sort_key) if p.is_dir()]
    levels: list[Path] = []
    for t in targets:
        p = MODULES_DIR / t
        if not p.exists():
            raise SystemExit(f"not found: {p}")
        if (p / "mission.yaml").exists():
            levels.append(p)
        else:
            levels.extend(sorted((d for d in p.iterdir() if d.is_dir()), key=sort_key))
    return levels


def check_structure(level: Path, res: Result) -> None:
    for f in REQUIRED_FILES:
        if not (level / f).is_file():
            res.errors.append(f"missing {f}")
    for d in ("broken", "solution"):
        if not (level / d).is_dir():
            res.errors.append(f"missing {d}/")
    if not (level / "mission.yaml").is_file():
        return
    try:
        mission = yaml.safe_load((level / "mission.yaml").read_text(encoding="utf-8")) or {}
    except yaml.YAMLError as exc:
        res.errors.append(f"mission.yaml invalid: {exc}")
        return
    for k in REQUIRED_MISSION_KEYS:
        if k not in mission or mission[k] in (None, "", []):
            res.errors.append(f"mission.yaml missing '{k}'")
    if mission.get("difficulty") not in DIFFICULTIES:
        res.errors.append(f"mission.yaml difficulty must be one of {sorted(DIFFICULTIES)}")
    if mission.get("module") != level.parent.name or mission.get("level") != level.name:
        res.errors.append("mission.yaml module/level do not match directory names")
    if not isinstance(mission.get("xp"), int):
        res.errors.append("mission.yaml xp must be an integer")

    for script in ("validate.sh", "setup.sh", "solution.sh"):
        sp = level / script
        if not sp.is_file():
            continue
        text = sp.read_text(encoding="utf-8")
        if 'source "$TM_LIB"' not in text:
            res.errors.append(f"{script} must start with: source \"$TM_LIB\"")
        if re.search(r"(^|[\s\"'=>])/tmp/", text):
            res.errors.append(f"{script} uses /tmp — use $TM_TMP instead")
        if re.search(r"^\s*set -e", text, re.M):
            res.errors.append(f"{script} uses set -e — the library handles exit codes; remove it")
    for d in ("broken", "solution"):
        if (level / d / ".terraform").exists():
            res.errors.append(f"{d}/ must not contain a .terraform/ directory")


def _tail(text: str, n: int = 25) -> str:
    lines = text.strip().splitlines()
    return "\n".join("      " + ln for ln in lines[-n:])


def run_scenario(level: Path, scenario: str, keep: bool) -> tuple[int, str]:
    tmp = Path(tempfile.mkdtemp(prefix=f"tm-test-{level.name}-{scenario}-"))
    ws = tmp / "workspace"
    try:
        level_id = f"{level.parent.name}/{level.name}"
        prepare_workspace(ws, level, level_id)
        if scenario == "solution":
            sol = apply_solution(ws, level)
            if sol is not None and sol.returncode != 0:
                return 99, f"solution.sh failed (exit {sol.returncode}):\n{_tail(sol.stdout + sol.stderr)}"
        elif scenario == "gutted":
            for f in list(ws.rglob("*.tf")) + list(ws.rglob("*.tftest.hcl")) + list(ws.rglob("*.tf.json")):
                if ".terraform" in f.parts or f.name == "terraform.tf":
                    continue
                f.unlink()
        r = run_validator(ws, level)
        out = (r.stdout or "") + (r.stderr or "")
        if scenario == "solution" and r.returncode == 0:
            r2 = run_validator(ws, level)
            if r2.returncode != 0:
                return 98, "second validator run failed (validator not idempotent):\n" + _tail(r2.stdout + r2.stderr)
        return r.returncode, out
    except SetupError as exc:
        return 97, f"setup failed: {exc}"
    finally:
        if keep:
            print(f"   kept {scenario}: {tmp}")
        else:
            shutil.rmtree(tmp, ignore_errors=True)


def test_level(level: Path, keep: bool) -> Result:
    res = Result(f"{level.parent.name}/{level.name}")
    t0 = time.time()
    check_structure(level, res)
    if res.errors:
        res.seconds = time.time() - t0
        return res

    code, out = run_scenario(level, "broken", keep)
    if code == 0:
        res.errors.append("broken config PASSES the validator (must fail)\n" + _tail(out))
    elif code != 1:
        res.errors.append(f"broken run exited {code} (validator must fail cleanly with exit 1 via tm_fail)\n" + _tail(out))
    elif "FAIL" not in out:
        res.warnings.append("broken run failed without a ❌ FAIL message")

    code, out = run_scenario(level, "solution", keep)
    if code != 0:
        res.errors.append(f"solution does NOT pass (exit {code})\n" + _tail(out))

    code, out = run_scenario(level, "gutted", keep)
    if code == 0:
        res.errors.append("gutted config (all .tf except terraform.tf deleted) PASSES — validator is too weak\n" + _tail(out))

    res.seconds = time.time() - t0
    return res


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("targets", nargs="*", help="module dir or module/level")
    ap.add_argument("--all", action="store_true")
    ap.add_argument("-j", "--jobs", type=int, default=3)
    ap.add_argument("--keep", action="store_true", help="keep temp workspaces")
    args = ap.parse_args()
    if not args.targets and not args.all:
        ap.error("give a module/level or --all")

    levels = select_levels(args.targets, args.all)
    print(f"Testing {len(levels)} level(s) with {args.jobs} worker(s)...\n")
    results: list[Result] = []
    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        futures = {pool.submit(test_level, lv, args.keep): lv for lv in levels}
        for fut in as_completed(futures):
            r = fut.result()
            results.append(r)
            mark = "✅" if r.ok else "❌"
            print(f"{mark} {r.level}  ({r.seconds:.0f}s)")
            for e in r.errors:
                print(f"   ERROR: {e}")
            for w in r.warnings:
                print(f"   warn:  {w}")

    failed = [r for r in results if not r.ok]
    print(f"\n{len(results) - len(failed)}/{len(results)} levels OK")
    if failed:
        print("FAILED: " + ", ".join(sorted(r.level for r in failed)))
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
