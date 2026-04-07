#!/usr/bin/env python3
"""Shared utilities for TerraformMissions level builders."""
from __future__ import annotations

import os
import stat
import textwrap
from pathlib import Path

import yaml

REPO_ROOT = Path(__file__).resolve().parent.parent
MODULES_DIR = REPO_ROOT / "modules"

# ── Default provider block (local + null + random + tls) ─────────────────────

DEFAULT_TERRAFORM_TF = """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}
"""

LOCAL_ONLY_TF = """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}
"""

NULL_ONLY_TF = """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}
"""

RANDOM_ONLY_TF = """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
"""

TLS_ONLY_TF = """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}
"""

# ── Validate.sh templates ─────────────────────────────────────────────────────

def validate_tf_validate() -> str:
    """Pass if 'terraform validate' succeeds."""
    return textwrap.dedent("""\
        #!/usr/bin/env bash
        set -euo pipefail

        if terraform validate -no-color 2>&1; then
            echo "✅ PASS: Configuration is valid"
            exit 0
        fi
        echo "❌ FAIL: terraform validate failed"
        exit 1
    """)


def validate_tf_plan() -> str:
    """Pass if 'terraform plan' exits 0 or 2 (no error)."""
    return textwrap.dedent("""\
        #!/usr/bin/env bash
        set -euo pipefail

        terraform plan -detailed-exitcode -no-color -input=false 2>&1
        CODE=$?
        if [[ $CODE -eq 0 ]] || [[ $CODE -eq 2 ]]; then
            echo "✅ PASS: terraform plan succeeded"
            exit 0
        fi
        echo "❌ FAIL: terraform plan returned error (exit $CODE)"
        exit 1
    """)


def validate_tf_apply() -> str:
    """Pass if 'terraform apply' succeeds."""
    return textwrap.dedent("""\
        #!/usr/bin/env bash
        set -euo pipefail

        if terraform apply -auto-approve -no-color -input=false 2>&1; then
            echo "✅ PASS: terraform apply succeeded"
            exit 0
        fi
        echo "❌ FAIL: terraform apply failed"
        exit 1
    """)


def validate_output_equals(output_name: str, expected_value: str) -> str:
    """Apply and check that a specific output equals the expected value."""
    return textwrap.dedent(f"""\
        #!/usr/bin/env bash
        set -euo pipefail

        if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
            cat /tmp/tf_out.txt
            echo "❌ FAIL: terraform apply failed"
            exit 1
        fi

        ACTUAL=$(terraform output -raw {output_name} 2>/dev/null || echo "__MISSING__")
        EXPECTED="{expected_value}"

        if [[ "$ACTUAL" == "$EXPECTED" ]]; then
            echo "✅ PASS: output '{output_name}' = '$ACTUAL'"
            exit 0
        fi
        echo "❌ FAIL: expected '$EXPECTED', got '$ACTUAL'"
        exit 1
    """)


def validate_file_exists_with_content(filepath: str, expected_content: str) -> str:
    """Apply and check a local file has the expected content."""
    return textwrap.dedent(f"""\
        #!/usr/bin/env bash
        set -euo pipefail

        if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
            cat /tmp/tf_out.txt
            echo "❌ FAIL: terraform apply failed"
            exit 1
        fi

        FILE="{filepath}"
        EXPECTED="{expected_content}"

        if [[ -f "$FILE" ]] && grep -qF "$EXPECTED" "$FILE"; then
            echo "✅ PASS: file '$FILE' contains expected content"
            exit 0
        fi
        echo "❌ FAIL: file '$FILE' missing or content incorrect"
        exit 1
    """)


def validate_state_contains(resource_addr: str) -> str:
    """Apply and verify a resource exists in the state."""
    return textwrap.dedent(f"""\
        #!/usr/bin/env bash
        set -euo pipefail

        if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
            cat /tmp/tf_out.txt
            echo "❌ FAIL: terraform apply failed"
            exit 1
        fi

        if terraform state show '{resource_addr}' > /dev/null 2>&1; then
            echo "✅ PASS: resource '{resource_addr}' exists in state"
            exit 0
        fi
        echo "❌ FAIL: resource '{resource_addr}' not found in state"
        exit 1
    """)


def validate_custom(script: str) -> str:
    """Custom validate.sh script."""
    return textwrap.dedent(script)


# ── Level writer ──────────────────────────────────────────────────────────────

def write_level(data: dict) -> Path:
    """
    Write all files for a level.

    data keys:
      module      str   e.g. "module-1-foundations"
      slug        str   e.g. "level-1-first-resource"
      mission     dict  mission.yaml fields (name, description, objective, xp, difficulty, expected_time, concepts)
      broken      dict  filename → content  (files in broken/)
      solution    dict  filename → content  (files in solution/)
      validate    str   validate.sh content
      hints       list  up to 3 hint strings
      debrief     str   debrief.md content
      common_mistakes str  common-mistakes.md content (optional)
    """
    module_dir = MODULES_DIR / data["module"]
    level_dir  = module_dir / data["slug"]
    level_dir.mkdir(parents=True, exist_ok=True)

    # mission.yaml
    mission = dict(data["mission"])
    mission["module"] = data["module"]
    mission["level"]  = data["slug"]
    (level_dir / "mission.yaml").write_text(
        yaml.dump(mission, default_flow_style=False, allow_unicode=True),
        encoding="utf-8",
    )

    # broken/
    broken_dir = level_dir / "broken"
    broken_dir.mkdir(exist_ok=True)
    for fpath, content in data.get("broken", {}).items():
        dest = broken_dir / fpath
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_text(content, encoding="utf-8")

    # solution/
    solution_dir = level_dir / "solution"
    solution_dir.mkdir(exist_ok=True)
    for fpath, content in data.get("solution", {}).items():
        dest = solution_dir / fpath
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_text(content, encoding="utf-8")

    # validate.sh (executable)
    validate_path = level_dir / "validate.sh"
    validate_path.write_text(data.get("validate", validate_tf_validate()), encoding="utf-8")
    validate_path.chmod(validate_path.stat().st_mode | stat.S_IEXEC | stat.S_IXGRP | stat.S_IXOTH)

    # hints
    for i, hint in enumerate(data.get("hints", []), 1):
        (level_dir / f"hint-{i}.txt").write_text(hint.strip(), encoding="utf-8")

    # debrief.md
    if data.get("debrief"):
        (level_dir / "debrief.md").write_text(data["debrief"].strip(), encoding="utf-8")

    # common-mistakes.md
    if data.get("common_mistakes"):
        (level_dir / "common-mistakes.md").write_text(data["common_mistakes"].strip(), encoding="utf-8")

    return level_dir


def print_done(module: str, count: int) -> None:
    print(f"  ✅  {module}  —  {count} levels written")
