#!/usr/bin/env python3
"""Module 4 — State Management (20 levels, Intermediate)."""
from __future__ import annotations

from scripts.build_utils import (
    LOCAL_ONLY_TF,
    NULL_ONLY_TF,
    RANDOM_ONLY_TF,
    print_done,
    validate_custom,
    validate_tf_apply,
    validate_tf_validate,
    write_level,
)

MODULE = "module-4-state-management"


def build() -> int:
    levels = [
        _level_01_state_inspect(),
        _level_02_state_move(),
        _level_03_state_remove(),
        _level_04_drift_detection(),
        _level_05_import_resource(),
        _level_06_import_block(),
        _level_07_moved_block(),
        _level_08_backend_local(),
        _level_09_lock_file(),
        _level_10_force_replace(),
        _level_11_targeted_apply(),
        _level_12_state_list(),
        _level_13_partial_config(),
        _level_14_refresh_only(),
        _level_15_state_pull(),
        _level_16_prevent_destroy_removal(),
        _level_17_tainted_resource(),
        _level_18_state_rm(),
        _level_19_output_from_state(),
        _level_20_state_surgery(),
    ]
    for lvl in levels:
        write_level(lvl)
    print_done(MODULE, len(levels))
    return len(levels)


# ─────────────────────────────────────────────────────────────────────────────
# Level 1 — state-inspect
# ─────────────────────────────────────────────────────────────────────────────
def _level_01_state_inspect():
    broken_main = """\
# Three random_string resources: alpha, beta, gamma
# The output mistakenly references a nonexistent resource "delta".

resource "random_string" "alpha" {
  length  = 8
  special = false
}

resource "random_string" "beta" {
  length  = 8
  special = false
}

resource "random_string" "gamma" {
  length  = 8
  special = false
}

# BUG: random_string.delta does not exist
output "last_string" {
  value = random_string.delta.result
}
"""
    solution_main = """\
resource "random_string" "alpha" {
  length  = 8
  special = false
}

resource "random_string" "beta" {
  length  = 8
  special = false
}

resource "random_string" "gamma" {
  length  = 8
  special = false
}

output "last_string" {
  value = random_string.gamma.result
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

for addr in random_string.alpha random_string.beta random_string.gamma; do
    if ! terraform state show "$addr" > /dev/null 2>&1; then
        echo "❌ FAIL: $addr not found in state"
        exit 1
    fi
done

OUT=$(terraform output -raw last_string 2>/dev/null || echo "__MISSING__")
if [[ "$OUT" == "__MISSING__" ]] || [[ -z "$OUT" ]]; then
    echo "❌ FAIL: output 'last_string' is missing or empty"
    exit 1
fi

echo "✅ PASS: all resources in state and output 'last_string' = '$OUT'"
exit 0
""")
    return {
        "module": MODULE,
        "slug": "level-1-state-inspect",
        "mission": {
            "name": "State Inspector",
            "description": "A config creates three `random_string` resources (alpha, beta, gamma) but the output references a nonexistent resource named `delta`.",
            "objective": "Fix the output so it references `random_string.gamma.result`. Then `terraform apply` must succeed and the output must be populated.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["state list", "state show", "resource references"],
        },
        "broken": {"terraform.tf": RANDOM_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": RANDOM_ONLY_TF, "main.tf": solution_main},
        "validate": validate,
        "hints": [
            "Run `terraform validate`. It will tell you the resource address that cannot be resolved.",
            "Use `terraform state list` after applying to see what resource names actually exist in state.",
            "Change `random_string.delta.result` in the output to `random_string.gamma.result`.",
        ],
        "debrief": """\
# State Inspector

## What Was Broken
The output block referenced `random_string.delta.result`, but no resource named `delta` was declared
in the configuration. Terraform cannot resolve references to undeclared resources.

## The Fix
```hcl
output "last_string" {
  value = random_string.gamma.result
}
```

## State Inspection Commands
```bash
terraform state list          # list all resources tracked in state
terraform state show <addr>   # show attributes of a specific resource
terraform output <name>       # print an output value
```

## Why It Matters
Understanding how to read state is fundamental. `terraform state list` gives you a quick
inventory of everything Terraform is managing, and `terraform state show` lets you inspect
each resource's current attribute values without applying any changes.
""",
        "common_mistakes": """\
# Common Mistakes

- **Typo in resource name** — resource names are case-sensitive; `Gamma` ≠ `gamma`.
- **Confusing resource type with name** — `random_string.gamma` means type=`random_string`, name=`gamma`.
- **Forgetting to run validate before plan** — `terraform validate` catches reference errors immediately.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 2 — state-move
# ─────────────────────────────────────────────────────────────────────────────
def _level_02_state_move():
    broken_main = """\
# A local_file resource — the filename attribute is missing, which will
# cause terraform apply to fail.

resource "local_file" "old_name" {
  content  = "managed by terraform"
  # BUG: filename attribute is missing
}
"""
    solution_main = """\
resource "local_file" "old_name" {
  content  = "managed by terraform"
  filename = "${path.module}/managed.txt"
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

if ! terraform state mv local_file.old_name local_file.new_name > /tmp/mv_out.txt 2>&1; then
    cat /tmp/mv_out.txt
    echo "❌ FAIL: terraform state mv failed"
    exit 1
fi

if terraform state show 'local_file.new_name' > /dev/null 2>&1; then
    echo "✅ PASS: local_file.new_name exists in state after mv"
    exit 0
fi
echo "❌ FAIL: local_file.new_name not found after state mv"
exit 1
""")
    return {
        "module": MODULE,
        "slug": "level-2-state-move",
        "mission": {
            "name": "State Mover",
            "description": "A `local_file` resource is declared but the `filename` attribute is missing, preventing apply. After the fix the validator will rename the resource in state with `terraform state mv`.",
            "objective": "Add the missing `filename` attribute so `terraform apply` succeeds. The validator will then run `terraform state mv local_file.old_name local_file.new_name` and verify the new address exists in state.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["terraform state mv", "resource renaming"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate,
        "hints": [
            "Run `terraform validate` — it will report that `filename` is a required argument for `local_file`.",
            "The `local_file` resource requires both `content` (or `source`) and `filename`. Add `filename = \"${path.module}/managed.txt\"`.",
            "`terraform state mv <old> <new>` renames a resource in state without destroying and recreating it — useful when you rename a resource in code.",
        ],
        "debrief": """\
# State Mover

## What Was Broken
The `local_file` resource was missing the required `filename` argument. Without it, `terraform apply`
fails immediately.

## The Fix
```hcl
resource "local_file" "old_name" {
  content  = "managed by terraform"
  filename = "${path.module}/managed.txt"
}
```

## terraform state mv
`terraform state mv` moves a resource from one address to another **within the same state file**
without destroying and recreating the actual resource. This is essential when you rename a resource
in your configuration — without a `moved {}` block or a `state mv`, Terraform would destroy the old
one and create a new one.

```bash
terraform state mv local_file.old_name local_file.new_name
```

## Why It Matters
Real-world refactoring often involves renaming resources. `state mv` is the escape hatch when
you can't (or don't want to) use a `moved {}` block.
""",
        "common_mistakes": """\
# Common Mistakes

- **Missing `filename`** — `local_file` always needs a filename.
- **Wrong address order** — `state mv` takes source first, destination second.
- **Not refreshing config after mv** — after `state mv`, update the resource name in `.tf` files too, or the next plan will show a delete+create.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 3 — state-remove
# ─────────────────────────────────────────────────────────────────────────────
def _level_03_state_remove():
    broken_main = """\
# Two local_file resources where each references the other's filename in its content.
# BUG: circular dependency — file_b's content references file_a's filename,
#      and file_a's content references file_b's filename.

resource "local_file" "file_a" {
  content  = "points to: ${local_file.file_b.filename}"
  filename = "${path.module}/file_a.txt"
}

resource "local_file" "file_b" {
  content  = "points to: ${local_file.file_a.filename}"
  filename = "${path.module}/file_b.txt"
}
"""
    solution_main = """\
resource "local_file" "file_a" {
  content  = "I am file A"
  filename = "${path.module}/file_a.txt"
}

resource "local_file" "file_b" {
  content  = "depends on: ${local_file.file_a.filename}"
  filename = "${path.module}/file_b.txt"
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed (check for circular dependency)"
    exit 1
fi

if ! terraform state rm local_file.file_b > /tmp/rm_out.txt 2>&1; then
    cat /tmp/rm_out.txt
    echo "❌ FAIL: terraform state rm failed"
    exit 1
fi

if terraform state show 'local_file.file_b' > /dev/null 2>&1; then
    echo "❌ FAIL: local_file.file_b should have been removed from state"
    exit 1
fi

if terraform state show 'local_file.file_a' > /dev/null 2>&1; then
    echo "✅ PASS: apply succeeded, state rm worked, file_a still tracked"
    exit 0
fi
echo "❌ FAIL: local_file.file_a missing from state"
exit 1
""")
    return {
        "module": MODULE,
        "slug": "level-3-state-remove",
        "mission": {
            "name": "State Eraser",
            "description": "Two `local_file` resources form a circular dependency — each references the other's filename in its content. This makes `terraform apply` impossible.",
            "objective": "Break the circular dependency so `terraform apply` succeeds. The validator will then run `terraform state rm local_file.file_b` and verify the result.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["terraform state rm", "circular dependency", "dependency graph"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate,
        "hints": [
            "Run `terraform plan` — it will report a cycle error between `local_file.file_a` and `local_file.file_b`.",
            "Break the cycle: make `file_a` independent (use a static string for its content) and have `file_b` reference `file_a` — not the other way around.",
            "`terraform state rm <address>` removes a resource from the state file without destroying the actual resource on disk.",
        ],
        "debrief": """\
# State Eraser

## What Was Broken
`local_file.file_a` referenced `local_file.file_b.filename` in its content, while `local_file.file_b`
referenced `local_file.file_a.filename`. This created a circular dependency that Terraform cannot resolve.

## The Fix
Make `file_a` independent and establish a one-way dependency from `file_b` to `file_a`:
```hcl
resource "local_file" "file_a" {
  content  = "I am file A"
  filename = "${path.module}/file_a.txt"
}

resource "local_file" "file_b" {
  content  = "depends on: ${local_file.file_a.filename}"
  filename = "${path.module}/file_b.txt"
}
```

## terraform state rm
`terraform state rm` removes a resource from state without deleting the real resource.
Use cases:
- Resource is now managed outside Terraform
- You want Terraform to "forget" a resource without running a destroy

```bash
terraform state rm local_file.file_b
```

## Why It Matters
Circular dependencies are a common mistake when resources reference each other. Understanding the
dependency graph (visible via `terraform graph`) helps you design correct resource relationships.
""",
        "common_mistakes": """\
# Common Mistakes

- **Mutual references** — if A needs data from B and B needs data from A, you have a cycle. Use locals or break the dependency.
- **Wrong address in state rm** — the address must match exactly what `terraform state list` shows.
- **Confusing `state rm` with destroy** — `state rm` only removes tracking; the actual file stays on disk.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 4 — drift-detection
# ─────────────────────────────────────────────────────────────────────────────
def _level_04_drift_detection():
    broken_main = """\
variable "file_content" {
  type    = string
  default = "initial content"
}

# BUG: content uses wrong variable reference (trailing 's')
resource "local_file" "tracked" {
  content  = var.file_contents
  filename = "${path.module}/tracked.txt"
}
"""
    solution_main = """\
variable "file_content" {
  type    = string
  default = "initial content"
}

resource "local_file" "tracked" {
  content  = var.file_content
  filename = "${path.module}/tracked.txt"
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

# Simulate external drift by modifying the file directly
TF_FILE=$(find . -maxdepth 2 -name "tracked.txt" 2>/dev/null | head -1 || true)
if [[ -n "$TF_FILE" ]] && [[ -f "$TF_FILE" ]]; then
    echo "drifted content modified outside terraform" > "$TF_FILE"
fi

# plan with detailed exitcode — exit 2 means changes detected (drift)
terraform plan -detailed-exitcode -no-color -input=false > /tmp/plan_out.txt 2>&1
PLAN_EXIT=$?

if [[ $PLAN_EXIT -eq 2 ]]; then
    echo "✅ PASS: drift detected (plan exit code 2)"
    exit 0
elif [[ $PLAN_EXIT -eq 0 ]]; then
    echo "❌ FAIL: no drift detected (exit 0)"
    exit 1
else
    cat /tmp/plan_out.txt
    echo "❌ FAIL: terraform plan failed with error (exit $PLAN_EXIT)"
    exit 1
fi
""")
    return {
        "module": MODULE,
        "slug": "level-4-drift-detection",
        "mission": {
            "name": "Drift Detector",
            "description": "A `local_file` resource uses `var.file_contents` (with a trailing 's') but the variable is declared as `var.file_content`. Fix the reference so apply works, then the validator will simulate drift and verify it is detected.",
            "objective": "Fix the variable reference from `var.file_contents` to `var.file_content`. After apply, the validator modifies the file externally and checks that `terraform plan -detailed-exitcode` returns exit code 2 (drift detected).",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["drift", "terraform plan", "-detailed-exitcode"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate,
        "hints": [
            "Run `terraform validate` — it reports that `var.file_contents` is not declared. Check the variable name.",
            "The variable is declared as `file_content` (no trailing 's'). Fix the reference in the resource block.",
            "`terraform plan -detailed-exitcode` exits with code 0 (no changes), 1 (error), or 2 (changes needed). Code 2 after external modification means drift was detected.",
        ],
        "debrief": """\
# Drift Detector

## What Was Broken
The resource referenced `var.file_contents` but the variable was declared as `var.file_content`
(without the trailing 's'). Terraform cannot resolve undeclared variable references.

## The Fix
```hcl
resource "local_file" "tracked" {
  content  = var.file_content
  filename = "${path.module}/tracked.txt"
}
```

## Drift Detection
Drift occurs when the real-world state of a resource diverges from what Terraform has recorded.
Causes include manual changes, external automation, or provider-side modifications.

```bash
terraform plan -detailed-exitcode
# Exit 0 = no changes
# Exit 1 = error
# Exit 2 = changes detected (drift or config change)
```

## Why It Matters
Regular drift detection (often scheduled with `-detailed-exitcode` in CI pipelines) ensures your
infrastructure stays consistent with your code. Without it, silent drift accumulates and causes
unexpected behavior.
""",
        "common_mistakes": """\
# Common Mistakes

- **Typo in variable name** — `file_contents` vs `file_content`; Terraform will not autocorrect.
- **Assuming plan exit 0 means "healthy"** — exit 0 means no changes; drift appears as exit 2.
- **Not running refresh** — by default `terraform plan` refreshes state; `-refresh=false` skips this.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 5 — import-resource
# ─────────────────────────────────────────────────────────────────────────────
def _level_05_import_resource():
    broken_main = """\
# The validator will create a file at /tmp/tm_existing.txt, then attempt to
# import it using the filename declared here.
# BUG: the filename doesn't match the file that will be imported.

resource "local_file" "existing" {
  content  = "pre-existing file content"
  filename = "/tmp/tm_wrong_path.txt"
}
"""
    solution_main = """\
resource "local_file" "existing" {
  content  = "pre-existing file content"
  filename = "/tmp/tm_existing.txt"
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# Create the "pre-existing" file that simulates an out-of-band resource
printf 'pre-existing file content' > /tmp/tm_existing.txt

if ! terraform init -no-color -input=false > /tmp/init_out.txt 2>&1; then
    cat /tmp/init_out.txt
    echo "❌ FAIL: terraform init failed"
    exit 1
fi

if ! terraform import local_file.existing /tmp/tm_existing.txt > /tmp/import_out.txt 2>&1; then
    cat /tmp/import_out.txt
    echo "❌ FAIL: terraform import failed"
    exit 1
fi

if terraform state show 'local_file.existing' > /dev/null 2>&1; then
    echo "✅ PASS: local_file.existing imported and visible in state"
    exit 0
fi
echo "❌ FAIL: local_file.existing not found in state after import"
exit 1
""")
    return {
        "module": MODULE,
        "slug": "level-5-import-resource",
        "mission": {
            "name": "Resource Importer",
            "description": "A `local_file` resource is declared but its `filename` points to the wrong path. The validator will create `/tmp/tm_existing.txt` and attempt to import it — the config filename must match.",
            "objective": "Change the `filename` to `/tmp/tm_existing.txt` so the import command succeeds and the resource appears in state.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["terraform import", "resource adoption"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate,
        "hints": [
            "The import command uses the resource address and the resource's unique ID. For `local_file`, the ID is the file path.",
            "The `filename` in your config must match the path you pass to `terraform import`. Check both carefully.",
            "Change `/tmp/tm_wrong_path.txt` to `/tmp/tm_existing.txt` in the resource block.",
        ],
        "debrief": """\
# Resource Importer

## What Was Broken
The `filename` attribute pointed to `/tmp/tm_wrong_path.txt` but the import target was
`/tmp/tm_existing.txt`. For `local_file`, the resource ID **is** the filename path, so they must match.

## The Fix
```hcl
resource "local_file" "existing" {
  content  = "pre-existing file content"
  filename = "/tmp/tm_existing.txt"
}
```

## terraform import
`terraform import` brings an existing real-world resource under Terraform management:
```bash
terraform import <resource_address> <resource_id>
terraform import local_file.existing /tmp/tm_existing.txt
```

The resource ID format varies by resource type — check the provider documentation for the correct ID format.

## Why It Matters
When you take over infrastructure that was created manually (or by another tool), `import` lets
you adopt it into Terraform state without destroying and recreating it.
""",
        "common_mistakes": """\
# Common Mistakes

- **Mismatched ID** — the import ID must exactly match the resource's real-world identifier.
- **Importing without a config block** — the resource must be declared in `.tf` files before importing.
- **Content mismatch after import** — after import, run `terraform plan` to see if attributes differ; you may need to adjust config to prevent unwanted changes.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 6 — import-block
# ─────────────────────────────────────────────────────────────────────────────
def _level_06_import_block():
    broken_main = """\
# Terraform 1.5+ import block — declarative import.
# BUG: the id points to the wrong path.

import {
  to = local_file.config
  id = "/wrong/path/config.txt"
}

resource "local_file" "config" {
  content  = "configuration data"
  filename = "${path.module}/config.txt"
}
"""
    solution_main = """\
import {
  to = local_file.config
  id = "${path.module}/config.txt"
}

resource "local_file" "config" {
  content  = "configuration data"
  filename = "${path.module}/config.txt"
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# Create the config.txt file so the import block has something to import
echo "configuration data" > "$(pwd)/config.txt"

terraform plan -detailed-exitcode -no-color -input=false > /tmp/plan_out.txt 2>&1
PLAN_EXIT=$?
if [[ $PLAN_EXIT -eq 0 ]] || [[ $PLAN_EXIT -eq 2 ]]; then
    echo "✅ PASS: terraform plan succeeded with import block"
    exit 0
fi
cat /tmp/plan_out.txt
echo "❌ FAIL: terraform plan failed (exit $PLAN_EXIT)"
exit 1
""")
    return {
        "module": MODULE,
        "slug": "level-6-import-block",
        "mission": {
            "name": "Declarative Import",
            "description": "Terraform 1.5 introduced `import {}` blocks for declarative imports. The config has an `import` block with the wrong file path as the resource ID.",
            "objective": "Fix the `import` block's `id` to match `\"${path.module}/config.txt\"` — the same path used in the resource's `filename` attribute.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["import block", "TF 1.5+", "declarative import"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate,
        "hints": [
            "The `import {}` block requires `to` (the resource address) and `id` (the resource's real-world identifier).",
            "For `local_file`, the resource ID is the file path. It must match the `filename` attribute exactly.",
            "Change `id = \"/wrong/path/config.txt\"` to `id = \"${path.module}/config.txt\"`.",
        ],
        "debrief": """\
# Declarative Import

## What Was Broken
The `import` block's `id` pointed to `/wrong/path/config.txt` instead of `${path.module}/config.txt`.
The ID must match the actual file path that the `local_file` resource manages.

## The Fix
```hcl
import {
  to = local_file.config
  id = "${path.module}/config.txt"
}
```

## Import Blocks (Terraform 1.5+)
The `import {}` block is the modern, declarative way to import resources:
```hcl
import {
  to = <resource_address>
  id = "<resource_id>"
}
```

Unlike `terraform import` (CLI), import blocks are:
- Stored in version control
- Part of the plan phase (visible in `terraform plan`)
- Automatically removed after the first `terraform apply`

## Why It Matters
Declarative imports make the import process auditable and repeatable, fitting naturally into
GitOps workflows where every change is reviewed before being applied.
""",
        "common_mistakes": """\
# Common Mistakes

- **Wrong ID format** — check provider docs for the correct ID format per resource type.
- **`to` address not matching the resource declaration** — the `to` value must exactly reference the declared resource.
- **Forgetting Terraform version** — `import {}` blocks require Terraform >= 1.5.0.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 7 — moved-block
# ─────────────────────────────────────────────────────────────────────────────
def _level_07_moved_block():
    broken_main = """\
# The resource was renamed from "old_name" to "new_name" in the config,
# but no moved {} block was added. Without it, Terraform plans a destroy+create.
# BUG: missing moved {} block

resource "local_file" "new_name" {
  content  = "managed file content"
  filename = "${path.module}/managed.txt"
}
"""
    solution_main = """\
moved {
  from = local_file.old_name
  to   = local_file.new_name
}

resource "local_file" "new_name" {
  content  = "managed file content"
  filename = "${path.module}/managed.txt"
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

if terraform state show 'local_file.new_name' > /dev/null 2>&1; then
    echo "✅ PASS: local_file.new_name exists in state"
    exit 0
fi
echo "❌ FAIL: local_file.new_name not found in state"
exit 1
""")
    return {
        "module": MODULE,
        "slug": "level-7-moved-block",
        "mission": {
            "name": "The Moved Block",
            "description": "A resource was renamed from `old_name` to `new_name` in the configuration, but the `moved {}` block was forgotten. Without it, Terraform plans a destroy+create instead of a rename.",
            "objective": "Add a `moved { from = local_file.old_name  to = local_file.new_name }` block so `terraform apply` performs an in-place rename rather than destroy+create.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["moved block", "resource renaming", "non-destructive refactoring"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate,
        "hints": [
            "Run `terraform plan` — if you see a destroy of `local_file.old_name` and a create of `local_file.new_name`, that means Terraform doesn't know they're the same resource.",
            "A `moved {}` block tells Terraform to rename a resource in state during the next apply, avoiding destroy+create.",
            "Add `moved { from = local_file.old_name  to = local_file.new_name }` before the resource block.",
        ],
        "debrief": """\
# The Moved Block

## What Was Broken
The resource was renamed in the config without a `moved {}` block. Terraform saw `local_file.old_name`
disappear and `local_file.new_name` appear — and planned to destroy the old one and create a new one.

## The Fix
```hcl
moved {
  from = local_file.old_name
  to   = local_file.new_name
}

resource "local_file" "new_name" {
  content  = "managed file content"
  filename = "${path.module}/managed.txt"
}
```

## moved {} Block
Introduced in Terraform 1.1, `moved {}` blocks record resource renames in your configuration:
- No CLI commands needed
- Version-controlled and reviewable
- Automatically processed during `terraform apply`
- Can be removed after all consumers have applied the change

## Why It Matters
Without `moved {}`, renaming a resource causes unnecessary destroy+create cycles. In production,
this can mean downtime. The `moved {}` block makes refactoring safe.
""",
        "common_mistakes": """\
# Common Mistakes

- **Wrong address in `from`** — must match exactly what `terraform state list` shows for the old resource.
- **Leaving `moved {}` in code forever** — remove it after the rename is deployed to all environments.
- **Using `moved {}` for cross-module moves incorrectly** — the syntax is slightly different for module moves.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 8 — backend-local
# ─────────────────────────────────────────────────────────────────────────────
def _level_08_backend_local():
    broken_terraform_tf = """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
  # BUG: path points to a nonexistent directory
  backend "local" {
    path = "../../nonexistent/terraform.tfstate"
  }
}
"""
    solution_terraform_tf = """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
  backend "local" {
    path = "terraform.tfstate"
  }
}
"""
    main_tf = """\
resource "local_file" "readme" {
  content  = "Hello from state level 8"
  filename = "${path.module}/readme.txt"
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if ! terraform init -reconfigure -no-color -input=false > /tmp/init_out.txt 2>&1; then
    cat /tmp/init_out.txt
    echo "❌ FAIL: terraform init failed (check backend path)"
    exit 1
fi

terraform plan -detailed-exitcode -no-color -input=false > /tmp/plan_out.txt 2>&1
PLAN_EXIT=$?
if [[ $PLAN_EXIT -eq 0 ]] || [[ $PLAN_EXIT -eq 2 ]]; then
    echo "✅ PASS: terraform init and plan succeeded with local backend"
    exit 0
fi
cat /tmp/plan_out.txt
echo "❌ FAIL: terraform plan failed (exit $PLAN_EXIT)"
exit 1
""")
    return {
        "module": MODULE,
        "slug": "level-8-backend-local",
        "mission": {
            "name": "Backend Basics",
            "description": "The `terraform {}` block configures a local backend with a path that points to a nonexistent directory: `../../nonexistent/terraform.tfstate`. Terraform cannot initialise.",
            "objective": "Fix the backend `path` to use `\"terraform.tfstate\"` (in the current directory) so `terraform init` and `terraform plan` succeed.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["local backend", "backend configuration", "terraform init"],
        },
        "broken": {"terraform.tf": broken_terraform_tf, "main.tf": main_tf},
        "solution": {"terraform.tf": solution_terraform_tf, "main.tf": main_tf},
        "validate": validate,
        "hints": [
            "Run `terraform init` — the error will mention the backend path cannot be created or accessed.",
            "The `backend \"local\"` block's `path` attribute sets where the state file lives. Relative paths are relative to the working directory.",
            "Change `path = \"../../nonexistent/terraform.tfstate\"` to `path = \"terraform.tfstate\"`.",
        ],
        "debrief": """\
# Backend Basics

## What Was Broken
The local backend was configured with `path = "../../nonexistent/terraform.tfstate"`. The directory
`../../nonexistent/` does not exist, so Terraform cannot write the state file there.

## The Fix
```hcl
backend "local" {
  path = "terraform.tfstate"
}
```

## Local Backend
The `local` backend stores state as a file on the filesystem. It's the default backend when no
`backend {}` block is specified (defaulting to `terraform.tfstate` in the working directory).

```hcl
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
```

## Why It Matters
Backend configuration is critical — it determines where state is stored and how locking works.
A wrong path can prevent `terraform init` from completing, blocking all operations.
""",
        "common_mistakes": """\
# Common Mistakes

- **Relative path confusion** — paths in `backend "local"` are relative to the Terraform working directory, not the `.tf` file location.
- **Forgetting `-reconfigure`** — when changing backends, use `terraform init -reconfigure`.
- **Using local backend in teams** — local backend has no locking; use a remote backend (S3, GCS, etc.) for shared environments.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 9 — lock-file
# ─────────────────────────────────────────────────────────────────────────────
def _level_09_lock_file():
    broken_main = """\
# Uses random_string provider but the lock file has a wrong/stale hash.
# Fix: delete .terraform.lock.hcl and let terraform init -upgrade regenerate it.

resource "random_string" "token" {
  length  = 16
  special = false
}

output "token" {
  value = random_string.token.result
}
"""
    broken_lock = """\
# This is a deliberately broken .terraform.lock.hcl with wrong hashes.
# Terraform init will fail because the hashes don't match the actual provider.
provider "registry.terraform.io/hashicorp/random" {
  version     = "3.6.0"
  constraints = "~> 3.6"
  hashes = [
    "h1:FAKEHASHFAKEHASHFAKEHASHFAKEHASHFAKEHASH=",
    "zh:0000000000000000000000000000000000000000000000000000000000000000",
  ]
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# Remove the bad lock file so init can regenerate it
rm -f .terraform.lock.hcl

if ! terraform init -upgrade -no-color -input=false > /tmp/init_out.txt 2>&1; then
    cat /tmp/init_out.txt
    echo "❌ FAIL: terraform init -upgrade failed"
    exit 1
fi

if terraform validate -no-color 2>&1; then
    echo "✅ PASS: init -upgrade succeeded and lock file regenerated"
    exit 0
fi
echo "❌ FAIL: terraform validate failed after init"
exit 1
""")
    return {
        "module": MODULE,
        "slug": "level-9-lock-file",
        "mission": {
            "name": "Lock File Chaos",
            "description": "The `.terraform.lock.hcl` file contains deliberately wrong provider hashes. Terraform detects the mismatch and refuses to use the cached provider.",
            "objective": "Delete the broken `.terraform.lock.hcl` file so `terraform init -upgrade` can regenerate it with the correct hashes.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": [".terraform.lock.hcl", "provider locking", "terraform init -upgrade"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": broken_main,
            ".terraform.lock.hcl": broken_lock,
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": broken_main,
        },
        "validate": validate,
        "hints": [
            "Run `terraform init` — it will report a hash mismatch in `.terraform.lock.hcl`.",
            "The lock file records cryptographic hashes of providers to prevent tampering. A wrong hash means the file is corrupted or manually edited.",
            "Delete `.terraform.lock.hcl` and run `terraform init -upgrade` to regenerate it with correct hashes.",
        ],
        "debrief": """\
# Lock File Chaos

## What Was Broken
`.terraform.lock.hcl` contained fake hashes that don't match the actual provider binary.
Terraform verifies these hashes on every `init` to detect tampering or corruption.

## The Fix
Delete the broken lock file:
```bash
rm .terraform.lock.hcl
terraform init -upgrade
```

## .terraform.lock.hcl
The lock file:
- Records the exact provider versions and their cryptographic hashes
- Should be committed to version control
- Ensures all team members use the same provider version
- Is automatically updated by `terraform init -upgrade`

## Why It Matters
Provider lock files are a security and reproducibility feature. They prevent silent upgrades
or supply-chain attacks where a provider binary is swapped for a malicious one.
""",
        "common_mistakes": """\
# Common Mistakes

- **Editing lock files manually** — never edit `.terraform.lock.hcl` by hand; let Terraform manage it.
- **Not committing the lock file** — commit it so all team members use the same provider version.
- **Using `-upgrade` carelessly** — `-upgrade` allows version upgrades; omit it to strictly use the locked version.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 10 — force-replace
# ─────────────────────────────────────────────────────────────────────────────
def _level_10_force_replace():
    broken_main = """\
# A null_resource with a trigger. The application version was bumped to v2
# but someone forgot to update the trigger — so Terraform doesn't know it
# needs to replace the resource.
# BUG: trigger is still "v1" but should be "v2"

resource "null_resource" "task" {
  triggers = {
    version = "v1"
  }

  provisioner "local-exec" {
    command = "echo Task running at version v2"
  }
}
"""
    solution_main = """\
resource "null_resource" "task" {
  triggers = {
    version = "v2"
  }

  provisioner "local-exec" {
    command = "echo Task running at version v2"
  }
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# First apply to get v1 state
terraform apply -auto-approve -no-color -input=false > /dev/null 2>&1 || true

# With v2 trigger, plan should show replacement
terraform plan -detailed-exitcode -no-color -input=false > /tmp/plan_out.txt 2>&1
PLAN_EXIT=$?

if [[ $PLAN_EXIT -eq 2 ]]; then
    echo "✅ PASS: plan shows changes (trigger updated to v2)"
    exit 0
elif [[ $PLAN_EXIT -eq 0 ]]; then
    echo "❌ FAIL: plan shows no changes — trigger was not updated"
    exit 1
else
    cat /tmp/plan_out.txt
    echo "❌ FAIL: plan error (exit $PLAN_EXIT)"
    exit 1
fi
""")
    return {
        "module": MODULE,
        "slug": "level-10-force-replace",
        "mission": {
            "name": "Force Replace",
            "description": "A `null_resource` has a trigger version that wasn't updated when the application version bumped from v1 to v2. Terraform doesn't detect the change and won't replace the resource.",
            "objective": "Update the trigger value from `\"v1\"` to `\"v2\"` so that `terraform plan` shows the resource will be replaced.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["terraform apply -replace", "triggers", "force replacement", "null_resource"],
        },
        "broken": {"terraform.tf": NULL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": NULL_ONLY_TF, "main.tf": solution_main},
        "validate": validate,
        "hints": [
            "Triggers on `null_resource` cause replacement when their values change. If the trigger value is the same, Terraform sees no change.",
            "The version bumped to v2 but the trigger still says v1. Update `version = \"v1\"` to `version = \"v2\"`.",
            "Alternatively, you can force replacement any time with `terraform apply -replace=null_resource.task` without touching the config.",
        ],
        "debrief": """\
# Force Replace

## What Was Broken
The `null_resource` trigger still referenced `"v1"` even though the application moved to v2.
Since triggers hadn't changed, Terraform saw no reason to replace the resource.

## The Fix
```hcl
resource "null_resource" "task" {
  triggers = {
    version = "v2"
  }
  ...
}
```

## Triggers and Force Replace
`null_resource` triggers work like change detectors — when trigger values change, the resource
is replaced (destroyed and recreated), re-running all provisioners.

For one-off forced replacements without config changes:
```bash
terraform apply -replace=null_resource.task
```

## Why It Matters
Triggers are how you tell Terraform "this resource must run again when X changes." Common use
cases: re-running scripts when a config file changes, re-executing deployments when an image version bumps.
""",
        "common_mistakes": """\
# Common Mistakes

- **Forgetting to update triggers** — if you update what the resource does but not the trigger, it won't re-run.
- **Using `terraform taint` (deprecated)** — prefer `terraform apply -replace` in modern Terraform.
- **Triggers on dynamic values** — triggers that reference computed values (like resource IDs) may cause unintended replacements.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 11 — targeted-apply
# ─────────────────────────────────────────────────────────────────────────────
def _level_11_targeted_apply():
    broken_main = """\
# Three chained resources: A -> B -> C
# BUG: resource C references a nonexistent attribute "content_md5" from B

resource "local_file" "resource_a" {
  content  = "Resource A content"
  filename = "${path.module}/resource_a.txt"
}

resource "local_file" "resource_b" {
  content  = "Resource B — depends on A: ${local_file.resource_a.filename}"
  filename = "${path.module}/resource_b.txt"
}

# BUG: local_file has no exported attribute "content_md5"; use "filename"
resource "local_file" "resource_c" {
  content  = "Resource C — depends on B: ${local_file.resource_b.content_md5}"
  filename = "${path.module}/resource_c.txt"
}
"""
    solution_main = """\
resource "local_file" "resource_a" {
  content  = "Resource A content"
  filename = "${path.module}/resource_a.txt"
}

resource "local_file" "resource_b" {
  content  = "Resource B — depends on A: ${local_file.resource_a.filename}"
  filename = "${path.module}/resource_b.txt"
}

resource "local_file" "resource_c" {
  content  = "Resource C — depends on B: ${local_file.resource_b.filename}"
  filename = "${path.module}/resource_c.txt"
}
"""
    return {
        "module": MODULE,
        "slug": "level-11-targeted-apply",
        "mission": {
            "name": "Targeted Apply",
            "description": "Three chained resources A → B → C exist, but C references `local_file.resource_b.content_md5` which is not an exported attribute of `local_file`.",
            "objective": "Fix the reference in `resource_c` from `.content_md5` to `.filename` so `terraform apply` succeeds for all three resources.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["-target flag", "dependency graph", "resource attributes"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_apply(),
        "hints": [
            "Run `terraform validate` — it reports that `local_file.resource_b` has no attribute named `content_md5`.",
            "Check the `local_file` provider docs: available exported attributes are `filename`, `content`, `id`, and `content_base64`.",
            "Change `local_file.resource_b.content_md5` to `local_file.resource_b.filename` in resource_c's content.",
        ],
        "debrief": """\
# Targeted Apply

## What Was Broken
`resource_c` referenced `local_file.resource_b.content_md5`. This attribute does not exist on
`local_file` resources. The valid exported attributes are `filename`, `content`, `id`, and `content_base64`.

## The Fix
```hcl
resource "local_file" "resource_c" {
  content  = "Resource C — depends on B: ${local_file.resource_b.filename}"
  filename = "${path.module}/resource_c.txt"
}
```

## The -target Flag
`terraform apply -target=<address>` applies changes to only specific resources and their
dependencies. Useful for:
- Debugging individual resources
- Partial rollouts (use cautiously)

```bash
terraform apply -target=local_file.resource_a
```

**Warning:** Using `-target` regularly leads to configuration drift. Prefer full applies.

## Why It Matters
Understanding the dependency graph (A to B to C) is essential for debugging. When C fails, check
if B's attributes are what C expects.
""",
        "common_mistakes": """\
# Common Mistakes

- **Referencing nonexistent attributes** — know your resource's exported attributes from provider docs.
- **Overusing `-target`** — it can leave state inconsistent; use sparingly and follow up with a full apply.
- **Assuming dependency order** — Terraform creates resources in dependency order; explicit `depends_on` is only needed when there's no attribute reference.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 12 — state-list
# ─────────────────────────────────────────────────────────────────────────────
def _level_12_state_list():
    broken_main = """\
# Five random resources, but one is named "count" — a Terraform meta-argument keyword.
# BUG: resource name "count" conflicts with the meta-argument keyword

resource "random_string" "alpha" {
  length  = 6
  special = false
}

resource "random_string" "beta" {
  length  = 6
  special = false
}

resource "random_string" "gamma" {
  length  = 6
  special = false
}

resource "random_string" "delta" {
  length  = 6
  special = false
}

# BUG: "count" is a reserved meta-argument name and cannot be used as a resource label
resource "random_string" "count" {
  length  = 6
  special = false
}
"""
    solution_main = """\
resource "random_string" "alpha" {
  length  = 6
  special = false
}

resource "random_string" "beta" {
  length  = 6
  special = false
}

resource "random_string" "gamma" {
  length  = 6
  special = false
}

resource "random_string" "delta" {
  length  = 6
  special = false
}

resource "random_string" "epsilon" {
  length  = 6
  special = false
}
"""
    return {
        "module": MODULE,
        "slug": "level-12-state-list",
        "mission": {
            "name": "State List and Naming",
            "description": "Five `random_string` resources are declared, but one is named `count` — a reserved Terraform meta-argument. This causes a validation error.",
            "objective": "Rename the `count` resource to a valid name (e.g., `epsilon`) so `terraform validate` passes.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["terraform state list", "reserved names", "resource naming"],
        },
        "broken": {"terraform.tf": RANDOM_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": RANDOM_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate` — it reports that `count` is a reserved name and cannot be used as a resource label.",
            "Terraform meta-arguments (`count`, `for_each`, `depends_on`, `provider`, `lifecycle`) cannot be used as resource names.",
            "Rename `random_string.count` to `random_string.epsilon` (or any other non-reserved name).",
        ],
        "debrief": """\
# State List and Naming

## What Was Broken
The resource was named `count`, which is a reserved Terraform meta-argument. Terraform uses `count`
as a special instruction inside resource blocks — it cannot also be a resource name.

## The Fix
```hcl
resource "random_string" "epsilon" {
  length  = 6
  special = false
}
```

## Reserved Names
These names cannot be used as resource labels:
- `count`
- `for_each`
- `depends_on`
- `provider`
- `lifecycle`
- `connection`
- `provisioner`

## terraform state list
After a successful apply, `terraform state list` shows all tracked resources:
```bash
terraform state list
# random_string.alpha
# random_string.beta
# random_string.gamma
# random_string.delta
# random_string.epsilon
```

## Why It Matters
Clear, non-reserved resource names make configurations readable and prevent conflicts with
Terraform's own meta-arguments.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using meta-argument names as resource names** — always avoid `count`, `for_each`, etc.
- **Starting names with numbers** — resource names must start with a letter or underscore.
- **Using hyphens in resource names** — use underscores (`my_resource`) not hyphens (`my-resource`).
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 13 — partial-config
# ─────────────────────────────────────────────────────────────────────────────
def _level_13_partial_config():
    broken_terraform_tf = """\
# BUG: backend block references var.state_path — variables cannot be used in
# backend configuration because the backend is initialised before variables
# are resolved.
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
  backend "local" {
    path = var.state_path
  }
}
"""
    broken_main = """\
variable "state_path" {
  type    = string
  default = "terraform.tfstate"
}

resource "local_file" "config" {
  content  = "partial config demo"
  filename = "${path.module}/config.txt"
}
"""
    solution_terraform_tf = """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
  backend "local" {
    path = "terraform.tfstate"
  }
}
"""
    solution_main = """\
variable "state_path" {
  type    = string
  default = "terraform.tfstate"
}

resource "local_file" "config" {
  content  = "partial config demo"
  filename = "${path.module}/config.txt"
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if ! terraform init -reconfigure -no-color -input=false > /tmp/init_out.txt 2>&1; then
    cat /tmp/init_out.txt
    echo "❌ FAIL: terraform init failed — backend config may still use variable reference"
    exit 1
fi

terraform plan -detailed-exitcode -no-color -input=false > /tmp/plan_out.txt 2>&1
PLAN_EXIT=$?
if [[ $PLAN_EXIT -eq 0 ]] || [[ $PLAN_EXIT -eq 2 ]]; then
    echo "✅ PASS: init and plan succeeded with literal backend path"
    exit 0
fi
cat /tmp/plan_out.txt
echo "❌ FAIL: plan failed (exit $PLAN_EXIT)"
exit 1
""")
    return {
        "module": MODULE,
        "slug": "level-13-partial-config",
        "mission": {
            "name": "Partial Backend Config",
            "description": "The `backend \"local\"` block references `var.state_path` — but variables cannot be used in backend configuration blocks. Terraform reports an error during init.",
            "objective": "Replace `var.state_path` with the literal string `\"terraform.tfstate\"` in the backend block so `terraform init` succeeds.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["partial backend config", "backend constraints", "terraform init"],
        },
        "broken": {"terraform.tf": broken_terraform_tf, "main.tf": broken_main},
        "solution": {"terraform.tf": solution_terraform_tf, "main.tf": solution_main},
        "validate": validate,
        "hints": [
            "Run `terraform init` — it says variables cannot be used in backend configuration.",
            "Backend blocks are evaluated before variables are resolved. They can only contain literal values.",
            "For dynamic backend config, use `-backend-config` flag or a separate `.tfbackend` file. For now, replace `var.state_path` with `\"terraform.tfstate\"`.",
        ],
        "debrief": """\
# Partial Backend Config

## What Was Broken
The backend block referenced `var.state_path`. Terraform's backend configuration is processed
**before** variables are evaluated, so variable references in backend blocks are not supported.

## The Fix
```hcl
backend "local" {
  path = "terraform.tfstate"
}
```

## Partial Backend Configuration
For dynamic backend values, use the `-backend-config` flag:
```bash
terraform init -backend-config="path=terraform.tfstate"
```

Or a separate file:
```hcl
# backend.tfbackend
path = "terraform.tfstate"
```
```bash
terraform init -backend-config=backend.tfbackend
```

## Why It Matters
Backend configuration must be static because it's needed to retrieve state — which happens
before any variable resolution. This is a fundamental Terraform bootstrap constraint.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using variables in backend blocks** — not supported; use `-backend-config` for dynamic values.
- **Using locals in backend blocks** — also not supported for the same reason.
- **Forgetting `-reconfigure`** — when you change the backend, run `terraform init -reconfigure`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 14 — refresh-only
# ─────────────────────────────────────────────────────────────────────────────
def _level_14_refresh_only():
    broken_main = """\
resource "local_file" "data" {
  content  = "refresh-only demo"
  filename = "${path.module}/data.txt"
}

# BUG: local_file has no exported attribute "size"
output "file_info" {
  value = local_file.data.size
}
"""
    solution_main = """\
resource "local_file" "data" {
  content  = "refresh-only demo"
  filename = "${path.module}/data.txt"
}

output "file_info" {
  value = local_file.data.filename
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: initial apply failed"
    exit 1
fi

# Apply refresh-only to update state
if ! terraform apply -refresh-only -auto-approve -no-color -input=false > /tmp/refresh_out.txt 2>&1; then
    cat /tmp/refresh_out.txt
    echo "❌ FAIL: terraform apply -refresh-only failed"
    exit 1
fi

echo "✅ PASS: apply and refresh-only both succeeded"
exit 0
""")
    return {
        "module": MODULE,
        "slug": "level-14-refresh-only",
        "mission": {
            "name": "Refresh Only",
            "description": "A `local_file` resource has an output that references `local_file.data.size` — an attribute that doesn't exist on `local_file`. Fix it so apply and `terraform apply -refresh-only` both work.",
            "objective": "Change the output to reference `local_file.data.filename` (a valid attribute) so the config applies and refresh-only mode works.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["-refresh-only", "state refresh", "output attributes"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate,
        "hints": [
            "Run `terraform validate` — `local_file` has no attribute `size`. Check the provider docs for valid attributes.",
            "Valid exported attributes for `local_file` include `filename`, `content`, `id`, and `content_base64`.",
            "Change `local_file.data.size` to `local_file.data.filename` in the output block.",
        ],
        "debrief": """\
# Refresh Only

## What Was Broken
The output referenced `local_file.data.size`, which is not an attribute exported by the
`local_file` resource. Valid attributes include `filename`, `content`, `id`, and `content_base64`.

## The Fix
```hcl
output "file_info" {
  value = local_file.data.filename
}
```

## terraform apply -refresh-only
`terraform apply -refresh-only` updates the state file to reflect reality without making any
infrastructure changes. It's the safe way to resync state after out-of-band changes:

```bash
terraform apply -refresh-only
```

Compare with:
- `terraform refresh` (deprecated) — did the same thing
- `terraform plan -refresh-only` — shows what would change in state without applying

## Why It Matters
Refresh-only mode is essential for reconciling drift without accidentally applying config changes.
Use it when you know the infrastructure changed externally and you want to accept those changes.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using deprecated attributes** — always check current provider docs for exported attribute names.
- **Confusing `-refresh-only` with `terraform refresh`** — `terraform refresh` is deprecated; use `-refresh-only` flag.
- **Applying refresh-only when you meant a full apply** — refresh-only never creates/modifies/destroys resources.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 15 — state-pull
# ─────────────────────────────────────────────────────────────────────────────
def _level_15_state_pull():
    _RANDOM_PASSWORD_TF = """\
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
    broken_main = """\
# BUG: random_password with invalid length — must be >= 1
resource "random_password" "secret" {
  length  = 0
  special = true
}

output "secret_length" {
  value = length(random_password.secret.result)
}
"""
    solution_main = """\
resource "random_password" "secret" {
  length  = 16
  special = true
}

output "secret_length" {
  value = length(random_password.secret.result)
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed (check random_password length)"
    exit 1
fi

STATE_VERSION=$(terraform state pull | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['version'])" 2>/dev/null || echo "")
if [[ -z "$STATE_VERSION" ]]; then
    echo "❌ FAIL: could not parse state version from terraform state pull"
    exit 1
fi

echo "✅ PASS: state pulled successfully, state format version = $STATE_VERSION"
exit 0
""")
    return {
        "module": MODULE,
        "slug": "level-15-state-pull",
        "mission": {
            "name": "State Pull Inspector",
            "description": "A `random_password` resource has `length = 0`, which is invalid. Fix the length so apply succeeds. The validator will then use `terraform state pull` to inspect the state JSON.",
            "objective": "Change `length = 0` to a valid value (e.g., `16`) so `terraform apply` succeeds and `terraform state pull` can read the state.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["terraform state pull", "state format", "random_password"],
        },
        "broken": {"terraform.tf": _RANDOM_PASSWORD_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": _RANDOM_PASSWORD_TF, "main.tf": solution_main},
        "validate": validate,
        "hints": [
            "Run `terraform validate` or `terraform apply` — `random_password` requires `length` to be at least 1.",
            "Change `length = 0` to `length = 16` (or any positive integer).",
            "`terraform state pull` outputs the raw state as JSON. You can pipe it to `python3 -m json.tool` or `jq` to inspect its structure.",
        ],
        "debrief": """\
# State Pull Inspector

## What Was Broken
`random_password` requires `length >= 1`. Setting `length = 0` causes an apply error because
the provider validates this constraint.

## The Fix
```hcl
resource "random_password" "secret" {
  length  = 16
  special = true
}
```

## terraform state pull
`terraform state pull` downloads the current state and prints it as JSON to stdout:
```bash
terraform state pull
terraform state pull | python3 -m json.tool    # pretty-print
terraform state pull | jq '.resources[].type'  # extract resource types
```

The state JSON structure:
```json
{
  "version": 4,
  "terraform_version": "1.5.x",
  "resources": [...],
  "outputs": {...}
}
```

## Why It Matters
Direct state inspection is useful for debugging, auditing, and building tooling around Terraform.
Always treat state as sensitive data — it may contain secrets.
""",
        "common_mistakes": """\
# Common Mistakes

- **Setting length = 0** — all random resource lengths must be positive.
- **Exposing state output** — `state pull` shows sensitive values (passwords, keys) in plaintext.
- **Editing state JSON manually** — never edit state directly; use `state mv`, `state rm`, or `state push` for state manipulation.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 16 — prevent-destroy-removal
# ─────────────────────────────────────────────────────────────────────────────
def _level_16_prevent_destroy_removal():
    broken_main = """\
# A resource protected by prevent_destroy = true
# BUG: prevent_destroy blocks the destroy plan

resource "local_file" "protected" {
  content  = "this file is protected"
  filename = "${path.module}/protected.txt"

  lifecycle {
    prevent_destroy = true
  }
}
"""
    solution_main = """\
resource "local_file" "protected" {
  content  = "this file is protected"
  filename = "${path.module}/protected.txt"

  lifecycle {
    prevent_destroy = false
  }
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

terraform plan -destroy -detailed-exitcode -no-color -input=false > /tmp/destroy_out.txt 2>&1
PLAN_EXIT=$?

if [[ $PLAN_EXIT -eq 0 ]] || [[ $PLAN_EXIT -eq 2 ]]; then
    echo "✅ PASS: destroy plan succeeded (prevent_destroy is not blocking)"
    exit 0
fi

if grep -q "prevent_destroy" /tmp/destroy_out.txt 2>/dev/null; then
    echo "❌ FAIL: prevent_destroy is still set to true"
else
    cat /tmp/destroy_out.txt
    echo "❌ FAIL: destroy plan failed (exit $PLAN_EXIT)"
fi
exit 1
""")
    return {
        "module": MODULE,
        "slug": "level-16-prevent-destroy-removal",
        "mission": {
            "name": "Prevent Destroy Removal",
            "description": "A `local_file` resource has `lifecycle { prevent_destroy = true }`. This blocks any destroy operation. The validator checks that a destroy plan succeeds — so `prevent_destroy` must be removed or set to `false`.",
            "objective": "Change `prevent_destroy = true` to `prevent_destroy = false` (or remove the lifecycle block) so `terraform plan -destroy` succeeds.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["prevent_destroy", "lifecycle", "destroy plan"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate,
        "hints": [
            "Run `terraform plan -destroy` — it will fail with a message about `prevent_destroy`.",
            "`prevent_destroy = true` in a `lifecycle` block causes Terraform to error if the resource would be destroyed, even in a plan.",
            "Change `prevent_destroy = true` to `prevent_destroy = false`, or remove the `lifecycle` block entirely.",
        ],
        "debrief": """\
# Prevent Destroy Removal

## What Was Broken
`lifecycle { prevent_destroy = true }` guards against accidental destruction. While valuable
in production, it blocked the destroy plan in this exercise.

## The Fix
```hcl
lifecycle {
  prevent_destroy = false
}
```
Or remove the lifecycle block entirely.

## prevent_destroy
```hcl
resource "aws_rds_cluster" "database" {
  lifecycle {
    prevent_destroy = true
  }
}
```

`prevent_destroy = true` causes `terraform plan` (and `apply`) to error when the resource
would be destroyed — even for planned replacements triggered by attribute changes.

To destroy a resource with `prevent_destroy = true`:
1. Change it to `false` in code
2. `terraform apply` the change
3. Then `terraform destroy`

## Why It Matters
`prevent_destroy` is a safety net for critical resources (databases, state buckets). Understanding
when to add and remove it is part of responsible Terraform management.
""",
        "common_mistakes": """\
# Common Mistakes

- **Forgetting prevent_destroy on critical resources** — database clusters, state buckets should have it.
- **Not removing it before intentional destruction** — you must change the code before destroying.
- **Confusion with `ignore_changes`** — `ignore_changes` ignores attribute drift; `prevent_destroy` prevents resource deletion.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 17 — tainted-resource
# ─────────────────────────────────────────────────────────────────────────────
def _level_17_tainted_resource():
    broken_main = """\
# BUG: the resource is named "job" but the taint command targets "task".
# Rename the resource to "task" so taint can find it.

resource "null_resource" "job" {
  triggers = {
    run_id = "abc123"
  }

  provisioner "local-exec" {
    command = "echo Running job"
  }
}
"""
    solution_main = """\
resource "null_resource" "task" {
  triggers = {
    run_id = "abc123"
  }

  provisioner "local-exec" {
    command = "echo Running task"
  }
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

if ! terraform taint null_resource.task > /tmp/taint_out.txt 2>&1; then
    cat /tmp/taint_out.txt
    echo "❌ FAIL: terraform taint null_resource.task failed — resource may not exist"
    exit 1
fi

terraform plan -detailed-exitcode -no-color -input=false > /tmp/plan_out.txt 2>&1
PLAN_EXIT=$?
if [[ $PLAN_EXIT -eq 2 ]]; then
    echo "✅ PASS: taint succeeded and plan shows replacement"
    exit 0
fi
cat /tmp/plan_out.txt
echo "❌ FAIL: plan should show replacement after taint (exit $PLAN_EXIT)"
exit 1
""")
    return {
        "module": MODULE,
        "slug": "level-17-tainted-resource",
        "mission": {
            "name": "Tainted Resource",
            "description": "A `null_resource` is named `job` but the validator tries to taint `null_resource.task`. Rename the resource to `task` so the taint command succeeds.",
            "objective": "Rename the `null_resource` from `job` to `task` so `terraform taint null_resource.task` succeeds and the plan shows replacement.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["terraform taint", "-replace", "force replacement"],
        },
        "broken": {"terraform.tf": NULL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": NULL_ONLY_TF, "main.tf": solution_main},
        "validate": validate,
        "hints": [
            "Run `terraform apply` then `terraform taint null_resource.task` — it will fail because the resource is named `job` not `task`.",
            "Check the resource name in `main.tf` — it says `null_resource.job`. The taint command targets `null_resource.task`.",
            "Rename `resource \"null_resource\" \"job\"` to `resource \"null_resource\" \"task\"`.",
        ],
        "debrief": """\
# Tainted Resource

## What Was Broken
The resource was named `null_resource.job` but the taint command targeted `null_resource.task`.
Terraform cannot taint a resource that doesn't exist in state.

## The Fix
```hcl
resource "null_resource" "task" {
  ...
}
```

## terraform taint (Legacy)
`terraform taint <address>` marks a resource for forced replacement on the next apply:
```bash
terraform taint null_resource.task
terraform plan   # shows: null_resource.task must be replaced
```

**Note:** `terraform taint` is deprecated. The modern approach is:
```bash
terraform apply -replace=null_resource.task
```

The `-replace` flag is preferred because:
- It combines taint + apply into one command
- It doesn't modify state separately
- It's explicit about what will happen

## Why It Matters
Force-replacing resources is necessary when a resource is in a broken state but Terraform
doesn't detect any configuration changes. Common cases: failed provisioners, corrupted resources.
""",
        "common_mistakes": """\
# Common Mistakes

- **Wrong resource address** — `terraform taint` and `-replace` require the exact address from `terraform state list`.
- **Using deprecated `taint`** — prefer `terraform apply -replace=<address>`.
- **Tainting in production without a plan** — always check `terraform plan` after tainting to understand the blast radius.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 18 — state-rm
# ─────────────────────────────────────────────────────────────────────────────
def _level_18_state_rm():
    broken_main = """\
# BUG: wrong resource type — "local_files" doesn't exist; should be "local_file"

resource "local_files" "config" {
  content  = "state rm demo"
  filename = "${path.module}/config.txt"
}
"""
    solution_main = """\
resource "local_file" "config" {
  content  = "state rm demo"
  filename = "${path.module}/config.txt"
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed (check resource type)"
    exit 1
fi

if ! terraform state rm local_file.config > /tmp/rm_out.txt 2>&1; then
    cat /tmp/rm_out.txt
    echo "❌ FAIL: terraform state rm failed"
    exit 1
fi

if terraform state show 'local_file.config' > /dev/null 2>&1; then
    echo "❌ FAIL: local_file.config still in state after rm"
    exit 1
fi

echo "✅ PASS: apply succeeded and state rm removed the resource"
exit 0
""")
    return {
        "module": MODULE,
        "slug": "level-18-state-rm",
        "mission": {
            "name": "State Remove",
            "description": "The resource is declared with type `local_files` (with a trailing 's') — this provider resource type doesn't exist. Fix the type so apply works, then the validator runs `terraform state rm`.",
            "objective": "Change `resource \"local_files\" \"config\"` to `resource \"local_file\" \"config\"` (remove the trailing 's') so apply succeeds and `terraform state rm` can clean it up.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["state rm", "resource type", "state cleanup"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate,
        "hints": [
            "Run `terraform validate` — it reports that `local_files` is not a valid resource type.",
            "The correct resource type for creating a local file is `local_file` (singular, no trailing 's').",
            "Change `resource \"local_files\" \"config\"` to `resource \"local_file\" \"config\"`.",
        ],
        "debrief": """\
# State Remove

## What Was Broken
`local_files` is not a valid resource type. The Hashicorp `local` provider provides `local_file`
(singular). The trailing 's' caused a provider validation error.

## The Fix
```hcl
resource "local_file" "config" {
  content  = "state rm demo"
  filename = "${path.module}/config.txt"
}
```

## terraform state rm
`terraform state rm` removes a resource from state without destroying the actual resource:
```bash
terraform state rm local_file.config
```

After `state rm`:
- The file still exists on disk
- Terraform no longer manages it
- The next `terraform plan` will show it as a new resource to create (if the config still declares it)

## Use Cases for state rm
- Migrating resources to a different state file
- Handing a resource over to another team or tool
- Emergency cleanup when a resource is stuck in a bad state

## Why It Matters
`state rm` is a powerful escape hatch. Use it carefully — it can leave real resources orphaned
and unmanaged.
""",
        "common_mistakes": """\
# Common Mistakes

- **Wrong resource type** — always check provider documentation for the exact resource type name.
- **Confusing state rm with destroy** — `state rm` does NOT delete the real resource.
- **Using state rm on the wrong address** — verify with `terraform state list` first.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 19 — output-from-state
# ─────────────────────────────────────────────────────────────────────────────
def _level_19_output_from_state():
    broken_main = """\
# BUG: terraform_remote_state points to a nonexistent path.
# The validator creates other.tfstate in the working directory.
# Fix the path to point there.

data "terraform_remote_state" "other" {
  backend = "local"
  config = {
    path = "/nonexistent/path/terraform.tfstate"
  }
}

output "remote_output" {
  value = data.terraform_remote_state.other.outputs
}
"""
    solution_main = """\
data "terraform_remote_state" "other" {
  backend = "local"
  config = {
    path = "${path.module}/other.tfstate"
  }
}

output "remote_output" {
  value = data.terraform_remote_state.other.outputs
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# Create a minimal "other" state file for the remote_state data source to read
cat > "$(pwd)/other.tfstate" << 'STATEOF'
{
  "version": 4,
  "terraform_version": "1.5.0",
  "serial": 1,
  "lineage": "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee",
  "outputs": {
    "greeting": {
      "value": "hello from other state",
      "type": "string"
    }
  },
  "resources": []
}
STATEOF

terraform plan -detailed-exitcode -no-color -input=false > /tmp/plan_out.txt 2>&1
PLAN_EXIT=$?
if [[ $PLAN_EXIT -eq 0 ]] || [[ $PLAN_EXIT -eq 2 ]]; then
    echo "✅ PASS: plan succeeded — remote state path is correct"
    exit 0
fi

if grep -qE "No such file|does not exist|nonexistent" /tmp/plan_out.txt 2>/dev/null; then
    echo "❌ FAIL: remote state file not found — fix the path"
else
    cat /tmp/plan_out.txt
    echo "❌ FAIL: plan failed (exit $PLAN_EXIT)"
fi
exit 1
""")
    return {
        "module": MODULE,
        "slug": "level-19-output-from-state",
        "mission": {
            "name": "Output from Remote State",
            "description": "A `terraform_remote_state` data source points to `/nonexistent/path/terraform.tfstate`. The validator creates `other.tfstate` in the working directory — fix the path to point there.",
            "objective": "Change the `path` in the `terraform_remote_state` config to `\"${path.module}/other.tfstate\"` so Terraform can read outputs from the sibling state file.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["terraform_remote_state", "cross-state references", "state outputs"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate,
        "hints": [
            "Run `terraform plan` — it will fail because `/nonexistent/path/terraform.tfstate` doesn't exist.",
            "The validator creates `other.tfstate` in the current working directory. Update the path to point there.",
            "Change `path = \"/nonexistent/path/terraform.tfstate\"` to `path = \"${path.module}/other.tfstate\"`.",
        ],
        "debrief": """\
# Output from Remote State

## What Was Broken
The `terraform_remote_state` data source had an incorrect path. When the state file doesn't exist
at the specified path, Terraform cannot read the remote outputs and the plan fails.

## The Fix
```hcl
data "terraform_remote_state" "other" {
  backend = "local"
  config = {
    path = "${path.module}/other.tfstate"
  }
}
```

## terraform_remote_state
`data "terraform_remote_state"` reads outputs from another Terraform state file:
```hcl
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "my-tf-state"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_instance" "app" {
  subnet_id = data.terraform_remote_state.vpc.outputs.private_subnet_id
}
```

## Why It Matters
Cross-state references enable modular architectures where different teams manage different
infrastructure components, sharing only the outputs they need.
""",
        "common_mistakes": """\
# Common Mistakes

- **Wrong backend type** — the backend in `terraform_remote_state` must match where state is actually stored.
- **Missing outputs** — the remote state must have explicit `output` blocks; resource attributes are not automatically accessible.
- **Path or key mismatch** — for S3/GCS backends, verify the exact key path matches the source state file.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 20 — state-surgery
# ─────────────────────────────────────────────────────────────────────────────
def _level_20_state_surgery():
    broken_main = """\
# Complex scenario: 3 resources, one has wrong resource type.
# BUG: "local_files" does not exist — should be "local_file"
# BUG: output also references the wrong type

resource "local_file" "config_a" {
  content  = "config a"
  filename = "${path.module}/config_a.txt"
}

resource "local_files" "config_b" {
  content  = "config b"
  filename = "${path.module}/config_b.txt"
}

resource "local_file" "config_c" {
  content  = "config c"
  filename = "${path.module}/config_c.txt"
}

output "all_files" {
  value = [
    local_file.config_a.filename,
    local_files.config_b.filename,
    local_file.config_c.filename,
  ]
}
"""
    solution_main = """\
resource "local_file" "config_a" {
  content  = "config a"
  filename = "${path.module}/config_a.txt"
}

resource "local_file" "config_b" {
  content  = "config b"
  filename = "${path.module}/config_b.txt"
}

resource "local_file" "config_c" {
  content  = "config c"
  filename = "${path.module}/config_c.txt"
}

output "all_files" {
  value = [
    local_file.config_a.filename,
    local_file.config_b.filename,
    local_file.config_c.filename,
  ]
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed — check resource types"
    exit 1
fi

RESOURCE_COUNT=$(terraform state list 2>/dev/null | wc -l | tr -d ' ')
if [[ "$RESOURCE_COUNT" -eq 3 ]]; then
    echo "✅ PASS: apply succeeded — all 3 resources in state"
    exit 0
fi
echo "❌ FAIL: expected 3 resources in state, got $RESOURCE_COUNT"
terraform state list 2>/dev/null || true
exit 1
""")
    return {
        "module": MODULE,
        "slug": "level-20-state-surgery",
        "mission": {
            "name": "State Surgery",
            "description": "Three resources are declared, but `config_b` uses the invalid type `local_files`. Fix both the resource type and the output reference so all three resources apply and appear in state.",
            "objective": "Change `resource \"local_files\" \"config_b\"` to `resource \"local_file\" \"config_b\"` and fix the output. `terraform apply` must succeed with all 3 resources in state.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "25m",
            "concepts": ["state recovery", "resource types", "state list", "output expressions"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate,
        "hints": [
            "Run `terraform validate` — it reports `local_files` as an invalid resource type. The correct type is `local_file`.",
            "There are two things to fix: the resource type declaration AND the output reference. Search for all occurrences of `local_files` in `main.tf`.",
            "Change `resource \"local_files\" \"config_b\"` to `resource \"local_file\" \"config_b\"` and update the output to use `local_file.config_b.filename`.",
        ],
        "debrief": """\
# State Surgery

## What Was Broken
Two problems existed simultaneously:
1. `resource "local_files" "config_b"` — `local_files` is not a valid provider resource type
2. The output referenced `local_files.config_b.filename`, also using the wrong type

## The Fix
```hcl
resource "local_file" "config_b" {
  content  = "config b"
  filename = "${path.module}/config_b.txt"
}

output "all_files" {
  value = [
    local_file.config_a.filename,
    local_file.config_b.filename,
    local_file.config_c.filename,
  ]
}
```

## State Recovery Strategy
When multiple resources fail, approach systematically:
1. `terraform validate` — catch type and syntax errors first
2. Fix validation errors
3. `terraform plan` — catch semantic and reference errors
4. Fix plan errors
5. `terraform apply` — apply and verify with `terraform state list`

## Why It Matters
Real-world state issues often involve multiple errors. The skill is identifying which errors
are root causes vs. cascading symptoms. In this case, fixing the resource type resolves both
the validation error and the output reference simultaneously.
""",
        "common_mistakes": """\
# Common Mistakes

- **Fixing only the resource type but forgetting the output** — both must reference the correct type and name.
- **Partial fixes** — always run `terraform validate` AND `terraform plan` before concluding the fix is complete.
- **Assuming one error equals one fix** — a single wrong resource type can cause multiple downstream errors.
""",
    }


if __name__ == "__main__":
    build()
