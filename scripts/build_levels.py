#!/usr/bin/env python3
"""
TerraformMissions — master level builder.

Run this to generate all level files, then run generate_registry.py.

  python3 scripts/build_levels.py
  python3 scripts/generate_registry.py
"""
from __future__ import annotations

import sys
from pathlib import Path

# Allow running from any directory
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))


def main() -> int:
    built = 0

    # ── Import and run each module builder ───────────────────────────────────
    from scripts.build_module_01 import build as m01
    built += m01()

    from scripts.build_module_02 import build as m02
    built += m02()

    from scripts.build_module_03 import build as m03
    built += m03()

    from scripts.build_module_04 import build as m04
    built += m04()

    from scripts.build_module_05 import build as m05
    built += m05()

    from scripts.build_module_06 import build as m06
    built += m06()

    from scripts.build_module_07 import build as m07
    built += m07()

    from scripts.build_module_08 import build as m08
    built += m08()

    from scripts.build_module_09 import build as m09
    built += m09()

    from scripts.build_module_10 import build as m10
    built += m10()

    from scripts.build_module_11 import build as m11
    built += m11()

    from scripts.build_module_12 import build as m12
    built += m12()

    from scripts.build_module_13 import build as m13
    built += m13()

    from scripts.build_module_14 import build as m14
    built += m14()

    from scripts.build_module_15 import build as m15
    built += m15()

    print(f"\n🎯  Total levels built: {built}")
    print("Run:  python3 scripts/generate_registry.py")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
