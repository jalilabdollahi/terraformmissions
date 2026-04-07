#!/usr/bin/env python3
"""Module 13 — Debugging & Troubleshooting (18 levels, Advanced)."""
from __future__ import annotations

from scripts.build_utils import (
    DEFAULT_TERRAFORM_TF,
    LOCAL_ONLY_TF,
    print_done,
    validate_tf_apply,
    validate_tf_plan,
    validate_tf_validate,
    validate_custom,
    write_level,
)

MODULE = "module-13-debugging"


def build() -> int:
    levels = [
        _level_01_tf_log_debug(),
        _level_02_provider_error_message(),
        _level_03_plan_error_diagnosis(),
        _level_04_apply_error_partial(),
        _level_05_cycle_detection(),
        _level_06_unknown_value_propagation(),
        _level_07_perpetual_diff(),
        _level_08_lock_file_conflict(),
        _level_09_init_failure(),
        _level_10_provider_version_conflict(),
        _level_11_state_inconsistency(),
        _level_12_import_conflict(),
        _level_13_null_attribute_access(),
        _level_14_sensitive_value_error(),
        _level_15_for_each_unknown_key(),
        _level_16_complex_dependency_debug(),
        _level_17_type_mismatch_deep(),
        _level_18_crash_log_analysis(),
    ]
    for lvl in levels:
        write_level(lvl)
    print_done(MODULE, len(levels))
    return len(levels)


# ─────────────────────────────────────────────────────────────────────────────
# Level 1 — tf-log-debug
# ─────────────────────────────────────────────────────────────────────────────
def _level_01_tf_log_debug():
    return {
        "module": MODULE,
        "slug": "level-1-tf-log-debug",
        "mission": {
            "name": "Reading the Debug Logs",
            "description": (
                "A configuration has a broken provider source that causes `terraform init` to fail. "
                "The validate.sh uses `TF_LOG=DEBUG` to surface more detail. "
                "Fix the provider source so `terraform init` succeeds."
            ),
            "objective": "Correct the provider source from a fake registry to `hashicorp/local`.",
            "xp": 225,
            "difficulty": "advanced",
            "expected_time": "15m",
            "concepts": ["TF_LOG", "debugging", "terraform init", "provider source"],
        },
        "broken": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      # Bug: wrong registry — this provider does not exist
      source  = "fakecorp.example.com/fakens/local"
      version = "~> 2.5"
    }
  }
}
""",
            "main.tf": """\
resource "local_file" "debug_test" {
  content  = "debug log test"
  filename = "${path.module}/debug.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "debug_test" {
  content  = "debug log test"
  filename = "${path.module}/debug.txt"
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if TF_LOG=DEBUG terraform init -no-color 2>&1; then
    echo "PASS: terraform init succeeded"
    exit 0
fi
echo "FAIL: terraform init failed — check provider source"
exit 1
"""),
        "hints": [
            "Run `TF_LOG=DEBUG terraform init` and look at the output. The error will show that the provider registry `fakecorp.example.com` cannot be reached.",
            "The provider source `fakecorp.example.com/fakens/local` does not exist. The real HashiCorp local provider source is `hashicorp/local`.",
            "Change `source = \"fakecorp.example.com/fakens/local\"` to `source = \"hashicorp/local\"` in the `required_providers` block.",
        ],
        "debrief": """\
# Reading the Debug Logs

## What Was Broken
The `source` for the `local` provider pointed to a non-existent registry:
`fakecorp.example.com/fakens/local`. Terraform tried to connect to this registry and failed.

## The Fix
```hcl
required_providers {
  local = {
    source  = "hashicorp/local"
    version = "~> 2.5"
  }
}
```

## TF_LOG Levels
| Level | What it shows |
|---|---|
| `ERROR` | Only errors |
| `WARN` | Warnings and errors |
| `INFO` | Informational messages |
| `DEBUG` | Detailed operation trace |
| `TRACE` | Extremely verbose — all API calls |

## Why It Matters
`TF_LOG=DEBUG` is your first tool when `terraform init` fails for non-obvious reasons.
The debug output shows exactly which registry Terraform is trying to contact and what response it received.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using a custom registry path by accident** — short-form `hashicorp/local` expands to `registry.terraform.io/hashicorp/local`.
- **Forgetting that `TF_LOG` output goes to stderr** — pipe with `2>&1` to capture it.
- **Leaving `TF_LOG=DEBUG` set permanently** — it is very noisy; unset it after debugging.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 2 — provider-error-message
# ─────────────────────────────────────────────────────────────────────────────
def _level_02_provider_error_message():
    return {
        "module": MODULE,
        "slug": "level-2-provider-error-message",
        "mission": {
            "name": "Wrong Attribute Type",
            "description": (
                "The `local_file` resource has `file_permission = 644` (a number), but the provider "
                "requires a string. The error message from the provider tells you exactly what to fix."
            ),
            "objective": "Fix `file_permission` to be the string `\"0644\"`.",
            "xp": 225,
            "difficulty": "advanced",
            "expected_time": "15m",
            "concepts": ["provider error messages", "attribute types", "file permissions"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "permission test"
  filename = "${path.module}/config.txt"

  # Bug: file_permission must be a string, not a number
  file_permission = 644
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content         = "permission test"
  filename        = "${path.module}/config.txt"
  file_permission = "0644"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says the attribute `file_permission` has an incorrect value type — expected string, got number.",
            "File permission values in Terraform's `local_file` are octal strings. The number `644` is decimal, not octal — and it's the wrong type entirely.",
            "Change `file_permission = 644` to `file_permission = \"0644\"`. The leading `0` denotes the octal representation.",
        ],
        "debrief": """\
# Wrong Attribute Type

## What Was Broken
`file_permission = 644` passes a number. The `local_file` provider requires a string representing
the Unix file permission in octal notation.

## The Fix
```hcl
file_permission = "0644"
```

## File Permission Strings
- `"0644"` — owner read/write, group read, others read
- `"0600"` — owner read/write only (good for secrets)
- `"0755"` — owner read/write/execute, group and others read/execute

## Why It Matters
Type mismatches are one of the most common Terraform errors. The provider's error message
always tells you the expected type — reading it carefully saves debugging time.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using a number instead of a string** — `644` vs `"0644"`.
- **Forgetting the leading `0`** — `"644"` is parsed differently from `"0644"` (decimal vs octal notation).
- **Using `"0644"` when `"0600"` is needed for secrets** — always use the most restrictive permissions that work.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 3 — plan-error-diagnosis
# ─────────────────────────────────────────────────────────────────────────────
def _level_03_plan_error_diagnosis():
    return {
        "module": MODULE,
        "slug": "level-3-plan-error-diagnosis",
        "mission": {
            "name": "Plan Failure Forensics",
            "description": (
                "A `null_resource` has a trigger that references `local_file.nonexistent.id` — "
                "a resource that is not declared in the configuration. This causes `terraform plan` to fail."
            ),
            "objective": "Fix the trigger to reference a resource that actually exists in the config.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["plan errors", "resource references", "null_resource triggers"],
        },
        "broken": {
            "terraform.tf": DEFAULT_TERRAFORM_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "plan test"
  filename = "${path.module}/config.txt"
}

# Bug: trigger references local_file.nonexistent which doesn't exist
resource "null_resource" "watcher" {
  triggers = {
    config_id = local_file.nonexistent.id
  }
}
""",
        },
        "solution": {
            "terraform.tf": DEFAULT_TERRAFORM_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "plan test"
  filename = "${path.module}/config.txt"
}

resource "null_resource" "watcher" {
  triggers = {
    config_id = local_file.config.id
  }
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The error says `local_file.nonexistent` is not declared. Find where this reference is used.",
            "The `null_resource.watcher` trigger maps use `local_file.nonexistent.id`. There is no resource named `nonexistent` — only `config`.",
            "Change `local_file.nonexistent.id` to `local_file.config.id` in the triggers map.",
        ],
        "debrief": """\
# Plan Failure Forensics

## What Was Broken
`null_resource.watcher` referenced `local_file.nonexistent.id`, but no `local_file.nonexistent`
resource was declared. Terraform caught this at plan time.

## The Fix
```hcl
resource "null_resource" "watcher" {
  triggers = {
    config_id = local_file.config.id
  }
}
```

## Reading Plan Errors
Terraform's plan errors always include:
1. The file and line number
2. The undeclared reference
3. A suggestion for what might be intended

## Why It Matters
Plan errors due to dangling references are always safe — they mean nothing has been changed.
Fix the reference by matching it to a declared resource.
""",
        "common_mistakes": """\
# Common Mistakes

- **Wrong resource label** — `nonexistent` vs `config`. Copy labels directly from declarations.
- **Referencing a resource from a different module** — inter-module references require explicit output passing.
- **Typos in resource type** — `local_files` vs `local_file`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 4 — apply-error-partial
# ─────────────────────────────────────────────────────────────────────────────
def _level_04_apply_error_partial():
    return {
        "module": MODULE,
        "slug": "level-4-apply-error-partial",
        "mission": {
            "name": "Partial Apply Recovery",
            "description": (
                "Two resources exist. The first is valid; the second has `file_permission = 999` which "
                "is not a valid octal permission string, causing it to fail on apply. "
                "Fix the second resource so the full apply succeeds."
            ),
            "objective": "Fix `file_permission = 999` to a valid octal string like `\"0644\"`.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["partial apply recovery", "apply errors", "attribute validation"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "first" {
  content  = "first file"
  filename = "${path.module}/first.txt"
}

# Bug: file_permission "999" is not a valid octal permission string
resource "local_file" "second" {
  content         = "second file"
  filename        = "${path.module}/second.txt"
  file_permission = "999"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "first" {
  content  = "first file"
  filename = "${path.module}/first.txt"
}

resource "local_file" "second" {
  content         = "second file"
  filename        = "${path.module}/second.txt"
  file_permission = "0644"
}
""",
        },
        "validate": validate_tf_apply(),
        "hints": [
            "Run `terraform apply`. The first resource applies successfully, but the second fails with a `file_permission` validation error.",
            "The value `\"999\"` is not a valid Unix octal permission string. Valid values use octal digits (0-7) and are typically 4 characters starting with `0`.",
            "Change `file_permission = \"999\"` to `file_permission = \"0644\"` (or another valid octal permission).",
        ],
        "debrief": """\
# Partial Apply Recovery

## What Was Broken
`file_permission = "999"` is not a valid octal permission string. `9` is not an octal digit
(octal uses 0-7). The provider rejects this value during apply.

## The Fix
```hcl
file_permission = "0644"
```

## Partial Apply Situations
When an apply partially succeeds:
1. Resources that completed are now in state
2. Failed resources are not in state
3. Re-run `terraform apply` — already-created resources are no-ops

## Valid file_permission Values
- Must be a 4-character octal string: `"0644"`, `"0600"`, `"0755"`, `"0400"`
- Only digits 0-7 are valid in each position

## Why It Matters
Partial apply recovery is a key operational skill. Understanding which resources succeeded
and which failed helps you plan the remediation correctly.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using decimal digits in octal strings** — `8` and `9` are not octal digits.
- **Forgetting the leading `0`** — `"644"` is treated as a string but may not work as expected.
- **Panicking on partial apply** — run `terraform apply` again after fixing the error; Terraform handles idempotency.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 5 — cycle-detection
# ─────────────────────────────────────────────────────────────────────────────
def _level_05_cycle_detection():
    return {
        "module": MODULE,
        "slug": "level-5-cycle-detection",
        "mission": {
            "name": "The Infinite Loop",
            "description": (
                "`local_file.a` content references `local_file.b.filename` and `local_file.b` content "
                "references `local_file.a.filename`, creating a dependency cycle. "
                "Fix by using a local value to break the cycle."
            ),
            "objective": "Break the cycle by introducing a `local` value that both resources can reference without circular dependency.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["dependency cycle", "dependency graph", "locals"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Bug: a references b.filename and b references a.filename — cycle!
resource "local_file" "a" {
  content  = "file a references ${local_file.b.filename}"
  filename = "${path.module}/a.txt"
}

resource "local_file" "b" {
  content  = "file b references ${local_file.a.filename}"
  filename = "${path.module}/b.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
locals {
  a_path = "${path.module}/a.txt"
  b_path = "${path.module}/b.txt"
}

resource "local_file" "a" {
  content  = "file a references ${local.b_path}"
  filename = local.a_path
}

resource "local_file" "b" {
  content  = "file b references ${local.a_path}"
  filename = local.b_path
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error reports a dependency cycle between `local_file.a` and `local_file.b`.",
            "The cycle exists because `a.content` depends on `b.filename`, and `b.content` depends on `a.filename`. Terraform cannot determine which to create first.",
            "Break the cycle: use `local` values to pre-define the filenames. Both resources can reference `local.a_path` and `local.b_path` without depending on each other.",
        ],
        "debrief": """\
# The Infinite Loop

## What Was Broken
`local_file.a` referenced `local_file.b.filename`, and `local_file.b` referenced
`local_file.a.filename`. This creates a circular dependency — Terraform cannot determine
the order of creation.

## The Fix
Extract the filenames into `locals` that are computed independently:
```hcl
locals {
  a_path = "${path.module}/a.txt"
  b_path = "${path.module}/b.txt"
}
```
Both resources then reference `local.a_path` and `local.b_path` — no circular dependency.

## How Terraform Detects Cycles
Terraform builds a directed acyclic graph (DAG) of resource dependencies. If a cycle is
detected, `terraform validate` reports the cycle path.

## Why It Matters
Dependency cycles prevent Terraform from planning or applying. The fix is always to find the
indirect dependency (usually a known/static value) and extract it to a `local`.
""",
        "common_mistakes": """\
# Common Mistakes

- **Referencing computed attributes across resources that depend on each other** — use `locals` for static values.
- **Using `depends_on` to "fix" cycles** — `depends_on` cannot break a data cycle, only order operations.
- **Confusing ordering with dependency** — `depends_on` affects ordering; attribute references create data dependencies.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 6 — unknown-value-propagation
# ─────────────────────────────────────────────────────────────────────────────
def _level_06_unknown_value_propagation():
    return {
        "module": MODULE,
        "slug": "level-6-unknown-value-propagation",
        "mission": {
            "name": "Unknown at Plan Time",
            "description": (
                "A `random_string` result is used as the `count` value for a `local_file` resource. "
                "Since `random_string.result` is unknown until apply, Terraform cannot determine how "
                "many resources to plan."
            ),
            "objective": "Replace the unknown `count` value with a static integer.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["known after apply", "count constraints", "random provider"],
        },
        "broken": {
            "terraform.tf": DEFAULT_TERRAFORM_TF,
            "main.tf": """\
resource "random_string" "suffix" {
  length  = 4
  special = false
  numeric = true
  upper   = false
}

# Bug: count uses a value that is unknown until apply
resource "local_file" "items" {
  count    = length(random_string.suffix.result)
  content  = "item ${count.index}"
  filename = "${path.module}/item-${count.index}.txt"
}
""",
        },
        "solution": {
            "terraform.tf": DEFAULT_TERRAFORM_TF,
            "main.tf": """\
resource "random_string" "suffix" {
  length  = 4
  special = false
  numeric = true
  upper   = false
}

# Fixed: count uses a static value known at plan time
resource "local_file" "items" {
  count    = 4
  content  = "item ${count.index}"
  filename = "${path.module}/item-${count.index}.txt"
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The error says the `count` value depends on a resource attribute that is not known until apply.",
            "`random_string.suffix.result` is only computed during apply, so `length(random_string.suffix.result)` is unknown at plan time. Terraform cannot create a plan without knowing the count.",
            "Replace `count = length(random_string.suffix.result)` with the static value `count = 4` (matching the `length = 4` in the random_string resource).",
        ],
        "debrief": """\
# Unknown at Plan Time

## What Was Broken
`count = length(random_string.suffix.result)` depends on a value that is computed during apply.
Terraform requires `count` (and `for_each` keys) to be known at plan time so it can show you
exactly what will be created, updated, or destroyed.

## The Fix
Use a static value that is known before apply:
```hcl
count = 4
```

## What Can Be Unknown at Plan Time
| Attribute | Known at plan? |
|---|---|
| Static literals | Always |
| Variable defaults | Always |
| `random_string.result` | No — computed at apply |
| `local_file.filename` | Yes — set in config |

## Why It Matters
This constraint ensures Terraform plans are meaningful. If counts were unknown, the plan would
show "some number of resources" instead of exact counts.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using computed resource attributes in `count` or `for_each`** — these must be statically known.
- **Using `random_*` results as keys or counts** — random values are always unknown at plan time.
- **Confusing `length(list_variable)` (ok) with `length(resource.attr)` (may not be ok)** — it depends on whether the attribute is known at plan time.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 7 — perpetual-diff
# ─────────────────────────────────────────────────────────────────────────────
def _level_07_perpetual_diff():
    return {
        "module": MODULE,
        "slug": "level-7-perpetual-diff",
        "mission": {
            "name": "The Never-Ending Plan",
            "description": (
                "A `local_file` resource uses `content = timestamp()`. Since `timestamp()` returns a "
                "different value on every plan, Terraform always sees a diff and will never converge."
            ),
            "objective": "Fix the perpetual diff by using `lifecycle { ignore_changes = [content] }` or a static content value.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["perpetual diffs", "timestamp()", "lifecycle ignore_changes", "idempotency"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Bug: timestamp() returns a new value every time terraform plan runs,
# causing a perpetual diff — the file content will always appear changed.
resource "local_file" "log_marker" {
  content  = "Generated at: ${timestamp()}"
  filename = "${path.module}/marker.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "log_marker" {
  content  = "Generated at: deployment"
  filename = "${path.module}/marker.txt"

  lifecycle {
    ignore_changes = [content]
  }
}
""",
        },
        "validate": validate_tf_apply(),
        "hints": [
            "Run `terraform apply` twice. The second `terraform plan` still shows a change to `content` even though nothing real has changed. This is a perpetual diff.",
            "`timestamp()` is evaluated on every plan/apply. Each evaluation returns a different RFC 3339 timestamp, so Terraform always sees the content as changed.",
            "Either replace `timestamp()` with a static string, or add `lifecycle { ignore_changes = [content] }` to prevent content drift from triggering updates.",
        ],
        "debrief": """\
# The Never-Ending Plan

## What Was Broken
`content = "Generated at: ${timestamp()}"` uses a function that returns a different value
every time it is called. Terraform evaluates this on every plan, always producing a diff
compared to what's in the state.

## The Fix
Option 1 — static content:
```hcl
content = "Generated at: deployment"
```

Option 2 — ignore content changes:
```hcl
lifecycle {
  ignore_changes = [content]
}
```

## Functions That Cause Perpetual Diffs
- `timestamp()` — always returns current time
- `uuid()` — always returns a new UUID
- `bcrypt()` — non-deterministic by design

## Why It Matters
Perpetual diffs are noisy and obscure real changes. They can also trigger unnecessary resource
replacement if the content change causes a provider to detect drift.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `timestamp()` in resource content** — it evaluates to a different value each plan.
- **Using `uuid()` similarly** — same problem.
- **Over-using `ignore_changes`** — only ignore fields that are genuinely externally managed.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 8 — lock-file-conflict
# ─────────────────────────────────────────────────────────────────────────────
def _level_08_lock_file_conflict():
    _broken_lock = """\
# This file is maintained automatically by "terraform init".
# Manual edits may be lost in future updates.

provider "registry.terraform.io/hashicorp/local" {
  version     = "2.5.1"
  constraints = "~> 2.5"
  hashes = [
    "h1:BADHASH_CONFLICT_AAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
    "zh:BADHASH_CONFLICT_0000000000000000000000000000000000000000000000000000000000000000=",
  ]
}
"""
    return {
        "module": MODULE,
        "slug": "level-8-lock-file-conflict",
        "mission": {
            "name": "Lock File Hash Conflict",
            "description": (
                "The `.terraform.lock.hcl` contains an incorrect hash for the `local` provider, "
                "causing `terraform init` to fail with a hash verification error."
            ),
            "objective": "Delete the lock file so `terraform init` can regenerate it with the correct hashes.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["lock file conflicts", "provider hashes", "terraform init"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "test" {
  content  = "lock conflict test"
  filename = "${path.module}/test.txt"
}
""",
            ".terraform.lock.hcl": _broken_lock,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "test" {
  content  = "lock conflict test"
  filename = "${path.module}/test.txt"
}
""",
            # No .terraform.lock.hcl in solution — should be deleted and regenerated
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

rm -f .terraform.lock.hcl

if terraform init -no-color 2>&1 && terraform validate -no-color 2>&1; then
    echo "PASS: init and validate succeeded after removing corrupted lock file"
    exit 0
fi
echo "FAIL: init or validate failed"
exit 1
"""),
        "hints": [
            "Run `terraform init`. The error output mentions a hash mismatch for the provider. The lock file has invalid hashes.",
            "The `.terraform.lock.hcl` file was manually edited or corrupted — the hashes no longer match the real provider binary.",
            "Delete `.terraform.lock.hcl` with `rm -f .terraform.lock.hcl` and run `terraform init` again to regenerate it.",
        ],
        "debrief": """\
# Lock File Hash Conflict

## What Was Broken
The `.terraform.lock.hcl` contained fabricated hashes that do not match the real provider binary.
Terraform's hash verification detected the mismatch and aborted `init`.

## The Fix
```bash
rm -f .terraform.lock.hcl
terraform init
```

## Lock File Hash Verification
Terraform computes multiple hash types for downloaded providers:
- `h1:` — hash of the zip file
- `zh:` — hash of the extracted files

Both must match what the registry reported at lock time.

## Why It Matters
Hash verification is a supply chain security measure. Never manually edit the lock file.
If hashes mismatch, investigate whether the provider was tampered with before simply regenerating.
""",
        "common_mistakes": """\
# Common Mistakes

- **Manually editing the lock file** — the result is almost always a hash mismatch.
- **Checking in a corrupted lock file** — CI will fail for all team members.
- **Using `terraform init -upgrade` unnecessarily** — only use `-upgrade` when you actually want to update provider versions.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 9 — init-failure
# ─────────────────────────────────────────────────────────────────────────────
def _level_09_init_failure():
    return {
        "module": MODULE,
        "slug": "level-9-init-failure",
        "mission": {
            "name": "Provider Not Found",
            "description": (
                "The `required_providers` block specifies a provider from a fake registry "
                "`notarealregistry.example.com/fake/provider`. `terraform init` fails because "
                "this provider does not exist."
            ),
            "objective": "Replace the fake provider with the real `hashicorp/local` provider.",
            "xp": 225,
            "difficulty": "advanced",
            "expected_time": "15m",
            "concepts": ["init errors", "provider source", "required_providers"],
        },
        "broken": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    # Bug: this provider does not exist anywhere
    myfakelocal = {
      source  = "notarealregistry.example.com/fake/provider"
      version = "~> 1.0"
    }
  }
}
""",
            "main.tf": """\
resource "local_file" "init_test" {
  content  = "init failure test"
  filename = "${path.module}/init_test.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "init_test" {
  content  = "init failure test"
  filename = "${path.module}/init_test.txt"
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if terraform init -no-color 2>&1; then
    echo "PASS: terraform init succeeded"
    exit 0
fi
echo "FAIL: terraform init failed"
exit 1
"""),
        "hints": [
            "Run `terraform init`. The error says the provider at `notarealregistry.example.com/fake/provider` cannot be found.",
            "The provider name `myfakelocal` and source `notarealregistry.example.com/fake/provider` are both fabricated. The real provider you want is `hashicorp/local`.",
            "Replace the entire `required_providers` block with the correct `local` provider: `source = \"hashicorp/local\"` and `version = \"~> 2.5\"`.",
        ],
        "debrief": """\
# Provider Not Found

## What Was Broken
The provider source `notarealregistry.example.com/fake/provider` does not exist.
Terraform tried to contact this registry and received a connection error or 404.

## The Fix
Use the real HashiCorp local provider:
```hcl
required_providers {
  local = {
    source  = "hashicorp/local"
    version = "~> 2.5"
  }
}
```

## Provider Source Format
`<hostname>/<namespace>/<type>` — the `hostname` defaults to `registry.terraform.io` when omitted.
So `hashicorp/local` is shorthand for `registry.terraform.io/hashicorp/local`.

## Why It Matters
`terraform init` is the first command in every workflow. A failing init blocks all subsequent
steps. Always validate provider sources against the Terraform Registry.
""",
        "common_mistakes": """\
# Common Mistakes

- **Typo in provider namespace** — `hashicrop/local` vs `hashicorp/local`.
- **Using provider type as namespace** — `local/local` vs `hashicorp/local`.
- **Specifying a non-existent version** — combine source fix with version constraint fix.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 10 — provider-version-conflict
# ─────────────────────────────────────────────────────────────────────────────
def _level_10_provider_version_conflict():
    return {
        "module": MODULE,
        "slug": "level-10-provider-version-conflict",
        "mission": {
            "name": "Version Constraint Clash",
            "description": (
                "Two local modules in the same configuration require incompatible version constraints "
                "for the `local` provider: one requires `~> 2.4` and the other requires `>= 3.0`. "
                "These constraints cannot be satisfied simultaneously."
            ),
            "objective": "Align the provider version constraints in both modules so they are compatible.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["provider version conflicts", "version constraints", "module provider requirements"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "module_a" {
  source = "./modules/module_a"
}

module "module_b" {
  source = "./modules/module_b"
}
""",
            "modules/module_a/terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      # Bug: ~> 2.4 conflicts with module_b's >= 3.0
      version = "~> 2.4"
    }
  }
}
""",
            "modules/module_a/main.tf": """\
resource "local_file" "a_config" {
  content  = "module a config"
  filename = "${path.module}/a_config.txt"
}
""",
            "modules/module_b/terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      # Bug: >= 3.0 conflicts with module_a's ~> 2.4 (no version satisfies both)
      version = ">= 3.0"
    }
  }
}
""",
            "modules/module_b/main.tf": """\
resource "local_file" "b_config" {
  content  = "module b config"
  filename = "${path.module}/b_config.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "module_a" {
  source = "./modules/module_a"
}

module "module_b" {
  source = "./modules/module_b"
}
""",
            "modules/module_a/terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}
""",
            "modules/module_a/main.tf": """\
resource "local_file" "a_config" {
  content  = "module a config"
  filename = "${path.module}/a_config.txt"
}
""",
            "modules/module_b/terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}
""",
            "modules/module_b/main.tf": """\
resource "local_file" "b_config" {
  content  = "module b config"
  filename = "${path.module}/b_config.txt"
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if terraform init -no-color 2>&1; then
    echo "PASS: terraform init succeeded — provider constraints are compatible"
    exit 0
fi
echo "FAIL: terraform init failed — check provider version constraints"
exit 1
"""),
        "hints": [
            "Run `terraform init`. The error says no single version of `hashicorp/local` satisfies both `~> 2.4` and `>= 3.0`.",
            "Look in `modules/module_a/terraform.tf` and `modules/module_b/terraform.tf`. They have different version constraints for the same provider.",
            "Align both modules to use `version = \"~> 2.5\"`. This satisfies both modules with a compatible constraint.",
        ],
        "debrief": """\
# Version Constraint Clash

## What Was Broken
`module_a` required `~> 2.4` (any 2.x at or above 2.4) and `module_b` required `>= 3.0`.
There is no version that is simultaneously in the 2.x range AND at or above 3.0.

## The Fix
Align both modules to a compatible constraint:
```hcl
version = "~> 2.5"
```

## Version Constraint Operators
| Operator | Meaning |
|---|---|
| `~> 2.5` | `>= 2.5, < 3.0` |
| `>= 2.5` | 2.5 or higher |
| `>= 2.5, < 3.0` | explicit range |
| `= 2.5.1` | exact version |

## Why It Matters
Provider version conflicts are common when composing modules from different sources.
Always check that all modules in a configuration agree on compatible version ranges.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `>=` without an upper bound** — `>= 2.5` allows any future version including potentially breaking major versions.
- **Forgetting to check child module constraints** — all modules share the same provider instance in a configuration.
- **Using exact pinning in modules** — prefer ranges in modules so callers have flexibility.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 11 — state-inconsistency
# ─────────────────────────────────────────────────────────────────────────────
def _level_11_state_inconsistency():
    _stale_state = """\
{
  "version": 4,
  "terraform_version": "1.5.0",
  "serial": 1,
  "lineage": "00000000-0000-0000-0000-000000000000",
  "outputs": {},
  "resources": [
    {
      "mode": "managed",
      "type": "local_file",
      "name": "config",
      "provider": "provider[\\"registry.terraform.io/hashicorp/local\\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "content": "stale state content",
            "content_base64": null,
            "directory_permission": "0777",
            "file_permission": "0777",
            "filename": "/tmp/stale_config.txt",
            "id": "stale-id-0000",
            "sensitive_content": null,
            "source": null
          }
        }
      ]
    }
  ]
}
"""
    return {
        "module": MODULE,
        "slug": "level-11-state-inconsistency",
        "mission": {
            "name": "Ghost in the State",
            "description": (
                "A stale `terraform.tfstate` file is present that records `local_file.config` as existing, "
                "but the config tries to create it fresh. The state inconsistency causes an error. "
                "Fix: delete the stale state and apply cleanly."
            ),
            "objective": "Remove the stale state file so `terraform apply` creates the resource from scratch.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["state inconsistency", "stale state", "terraform state management"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "fresh config"
  filename = "${path.module}/config.txt"
}
""",
            "terraform.tfstate": _stale_state,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "fresh config"
  filename = "${path.module}/config.txt"
}
""",
            # No terraform.tfstate — the stale state has been deleted
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# Remove stale state file
rm -f terraform.tfstate terraform.tfstate.backup

if terraform init -no-color 2>&1 && terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "PASS: apply succeeded after removing stale state"
    exit 0
fi
echo "FAIL: apply failed"
exit 1
"""),
        "hints": [
            "Run `terraform plan`. It detects the state file and tries to reconcile it with the actual file at `/tmp/stale_config.txt` — which doesn't exist. This causes an inconsistency.",
            "The `terraform.tfstate` in the `broken/` directory is a stale artifact from a previous run in a different directory. It records a resource at `/tmp/stale_config.txt`.",
            "Delete `terraform.tfstate` (and `terraform.tfstate.backup` if present). Then run `terraform apply` to create the resource fresh.",
        ],
        "debrief": """\
# Ghost in the State

## What Was Broken
A stale `terraform.tfstate` was present, recording `local_file.config` as existing at
`/tmp/stale_config.txt`. The actual file doesn't exist at that path. Terraform's refresh
detected the inconsistency and reported an error.

## The Fix
```bash
rm -f terraform.tfstate terraform.tfstate.backup
terraform apply
```

## When State Becomes Inconsistent
1. State file copied from another environment
2. Resource manually deleted outside Terraform
3. State file from a different directory/workspace

## Recovery Options
- **Delete stale state** — for fully orphaned state files (as done here)
- **`terraform state rm`** — remove specific stale resource from state
- **`terraform import`** — if the real resource exists elsewhere and needs to be brought under management

## Why It Matters
State inconsistency is one of the most common real-world Terraform problems.
Understanding when to delete, import, or fix state is a critical operational skill.
""",
        "common_mistakes": """\
# Common Mistakes

- **Copying state files between environments without adjustment** — state is environment-specific.
- **Sharing state files in version control** — use remote state backends instead.
- **Deleting state without understanding what it tracked** — you may lose track of real resources.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 12 — import-conflict
# ─────────────────────────────────────────────────────────────────────────────
def _level_12_import_conflict():
    return {
        "module": MODULE,
        "slug": "level-12-import-conflict",
        "mission": {
            "name": "Already in State",
            "description": (
                "An `import` block tries to import `local_file.config` using the wrong address — "
                "it references `local_file.wrong_resource`. Fix the `to` address to match the "
                "declared resource."
            ),
            "objective": "Correct the `import` block's `to` address from `local_file.wrong_resource` to `local_file.config`.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["import conflicts", "import block", "resource addresses"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Bug: 'to' references local_file.wrong_resource which is not declared
import {
  to = local_file.wrong_resource
  id = "${path.module}/config.txt"
}

resource "local_file" "config" {
  content  = "imported config"
  filename = "${path.module}/config.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
import {
  to = local_file.config
  id = "${path.module}/config.txt"
}

resource "local_file" "config" {
  content  = "imported config"
  filename = "${path.module}/config.txt"
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The error says `local_file.wrong_resource` is not declared in the configuration.",
            "The `import` block's `to` argument must match a declared resource. The only `local_file` resource declared is `local_file.config`.",
            "Change `to = local_file.wrong_resource` to `to = local_file.config`.",
        ],
        "debrief": """\
# Already in State

## What Was Broken
`import { to = local_file.wrong_resource }` references a resource that is not declared.
The `to` address must correspond to an existing resource declaration in the configuration.

## The Fix
```hcl
import {
  to = local_file.config
  id = "${path.module}/config.txt"
}
```

## import Block Address Rules
- `to` must reference a resource declared in the current root module or a child module
- The address format is `resource_type.resource_label` or `module.label.resource_type.resource_label`
- The resource must NOT already be in state (that would be a conflict)

## Why It Matters
Getting the `to` address wrong either results in a validation error (undeclared resource)
or attempts to import into an already-managed resource (conflict error).
""",
        "common_mistakes": """\
# Common Mistakes

- **Wrong resource label in `to`** — must exactly match the declared label.
- **Importing into a resource that's already in state** — results in a conflict; use `terraform state show` to check first.
- **Confusing the `to` address with the actual resource ID** — `to` is the Terraform address; `id` is the provider-side identifier.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 13 — null-attribute-access
# ─────────────────────────────────────────────────────────────────────────────
def _level_13_null_attribute_access():
    return {
        "module": MODULE,
        "slug": "level-13-null-attribute-access",
        "mission": {
            "name": "Handling the Absent Value",
            "description": (
                "A `local` value accesses `data.local_file.maybe.content`, but the data source "
                "may fail if the file doesn't exist, propagating an error. "
                "Fix this by using `try()` to provide a default value."
            ),
            "objective": "Wrap the data source attribute access in `try()` to return a default string when the file is absent.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["null attribute access", "try()", "data source error handling"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# This data source will fail if the file doesn't exist
data "local_file" "maybe" {
  filename = "${path.module}/maybe_exists.txt"
}

# Bug: directly accessing data source content without handling the case where it fails
locals {
  file_content = data.local_file.maybe.content
}

resource "local_file" "result" {
  content  = local.file_content
  filename = "${path.module}/result.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
data "local_file" "maybe" {
  filename = "${path.module}/maybe_exists.txt"
}

locals {
  file_content = try(data.local_file.maybe.content, "default content")
}

resource "local_file" "result" {
  content  = local.file_content
  filename = "${path.module}/result.txt"
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The data source fails because `maybe_exists.txt` does not exist, and the error propagates to `local.file_content`.",
            "Terraform's `try()` function evaluates its arguments and returns the first one that does not produce an error. Use it to provide a fallback value.",
            "Wrap the access: `try(data.local_file.maybe.content, \"default content\")`.",
        ],
        "debrief": """\
# Handling the Absent Value

## What Was Broken
`local.file_content = data.local_file.maybe.content` will error if the data source fails.
The error propagates and prevents planning.

## The Fix
```hcl
locals {
  file_content = try(data.local_file.maybe.content, "default content")
}
```

## try() Function
`try(expression1, expression2, ...)` evaluates expressions left to right and returns the first
one that does not produce an error. If all fail, it throws the last error.

Use cases:
- Optional data source attributes
- Accessing attributes that may not exist in older provider versions
- Providing fallbacks for computed values

## Why It Matters
Real infrastructure often has optional components. `try()` enables graceful handling of absent
resources or missing attributes without failing the entire configuration.
""",
        "common_mistakes": """\
# Common Mistakes

- **Not using `try()` for optional data sources** — a missing file causes the entire plan to fail.
- **Using `try()` to hide real errors** — only use it for genuinely optional values.
- **Confusing `try()` with `can()`** — `can()` returns a bool; `try()` returns the value or falls back.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 14 — sensitive-value-error
# ─────────────────────────────────────────────────────────────────────────────
def _level_14_sensitive_value_error():
    return {
        "module": MODULE,
        "slug": "level-14-sensitive-value-error",
        "mission": {
            "name": "Sensitive Keys Forbidden",
            "description": (
                "A `for_each` uses a sensitive variable value as the map key. "
                "Terraform prohibits sensitive values as `for_each` keys because they would "
                "be exposed in the plan output. Fix by using `nonsensitive()` on the key."
            ),
            "objective": "Wrap the sensitive key with `nonsensitive()` so it can be used as a `for_each` key.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["sensitive value constraints", "for_each keys", "nonsensitive()"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "service_tokens" {
  type      = map(string)
  sensitive = true
  default = {
    web    = "token-web-001"
    api    = "token-api-002"
    worker = "token-worker-003"
  }
}

# Bug: for_each keys come from a sensitive variable — Terraform rejects this
resource "local_file" "service_config" {
  for_each = var.service_tokens

  content         = "service=${each.key}"
  filename        = "${path.module}/service-${each.key}.txt"
  file_permission = "0600"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "service_tokens" {
  type      = map(string)
  sensitive = true
  default = {
    web    = "token-web-001"
    api    = "token-api-002"
    worker = "token-worker-003"
  }
}

# Fixed: wrap with nonsensitive() so keys can be used in for_each
# The keys (service names) are not themselves sensitive; only the values (tokens) are.
resource "local_file" "service_config" {
  for_each = nonsensitive(var.service_tokens)

  content         = "service=${each.key}"
  filename        = "${path.module}/service-${each.key}.txt"
  file_permission = "0600"
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The error says the `for_each` value is derived from a sensitive value, which is not allowed.",
            "Terraform prevents sensitive values from being used as `for_each` keys because the keys appear in plan output and state addresses.",
            "Wrap `var.service_tokens` with `nonsensitive()`: `for_each = nonsensitive(var.service_tokens)`. This tells Terraform the keys are safe to expose.",
        ],
        "debrief": """\
# Sensitive Keys Forbidden

## What Was Broken
`for_each = var.service_tokens` used a sensitive variable. Terraform cannot use sensitive values
as `for_each` keys because the keys appear in resource addresses and plan output.

## The Fix
```hcl
for_each = nonsensitive(var.service_tokens)
```

## nonsensitive() vs sensitive()
- `sensitive(value)` — marks a value as sensitive (hides it in output)
- `nonsensitive(value)` — asserts that a value is safe to expose (removes sensitivity marking)

## When to Use nonsensitive()
Only when the value is genuinely non-sensitive (e.g., service names as keys, even if the
overall map is sensitive). Never use `nonsensitive()` on actual secrets.

## Why It Matters
This constraint prevents resource addresses (which appear in logs and state) from containing
secret values. If you need sensitive keys, restructure to use non-sensitive keys separately.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `nonsensitive()` on actual secrets** — only the keys need to be non-sensitive.
- **Marking entire maps as sensitive when only values are sensitive** — use `sensitive()` on individual outputs instead.
- **Confusing `sensitive = true` on variables with attribute-level sensitivity** — they behave differently.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 15 — for-each-unknown-key
# ─────────────────────────────────────────────────────────────────────────────
def _level_15_for_each_unknown_key():
    return {
        "module": MODULE,
        "slug": "level-15-for-each-unknown-key",
        "mission": {
            "name": "Unknown for_each Keys",
            "description": (
                "A `for_each` uses a map derived from `random_string` results as keys. "
                "Since `random_string.result` is unknown until apply, the `for_each` keys "
                "are unknown at plan time — which Terraform does not allow."
            ),
            "objective": "Replace the unknown `for_each` key with a predetermined, static key.",
            "xp": 325,
            "difficulty": "advanced",
            "expected_time": "25m",
            "concepts": ["for_each key must be known", "known after apply", "for_each constraints"],
        },
        "broken": {
            "terraform.tf": DEFAULT_TERRAFORM_TF,
            "main.tf": """\
resource "random_string" "ids" {
  count   = 3
  length  = 8
  special = false
}

# Bug: for_each keys come from random_string.result which is unknown at plan time
resource "local_file" "items" {
  for_each = { for r in random_string.ids : r.result => r.result }

  content  = "item ${each.key}"
  filename = "${path.module}/item-${each.key}.txt"
}
""",
        },
        "solution": {
            "terraform.tf": DEFAULT_TERRAFORM_TF,
            "main.tf": """\
resource "random_string" "ids" {
  count   = 3
  length  = 8
  special = false
}

# Fixed: use predetermined static keys; random values are used only in content
resource "local_file" "items" {
  for_each = toset(["item-0", "item-1", "item-2"])

  content  = "item ${each.key}"
  filename = "${path.module}/item-${each.key}.txt"
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The error says the `for_each` map includes values derived from resource attributes that won't be known until apply.",
            "`random_string.ids[*].result` values are unknown at plan time. Terraform needs to know the full set of `for_each` keys before applying to create a complete plan.",
            "Use a static set of keys instead: `for_each = toset([\"item-0\", \"item-1\", \"item-2\"])`. The random values can still be used in resource content if needed.",
        ],
        "debrief": """\
# Unknown for_each Keys

## What Was Broken
`for_each = { for r in random_string.ids : r.result => r.result }` uses computed `result`
values as keys. Since these are unknown at plan time, Terraform cannot enumerate the instances
that will be created.

## The Fix
Use static, predetermined keys:
```hcl
for_each = toset(["item-0", "item-1", "item-2"])
```

## for_each Key Requirements
- Keys must be **known at plan time**
- Keys must be **strings or null** (not sensitive values)
- Keys must form a **finite, deterministic set**

## Why It Matters
Terraform builds its execution plan by enumerating all resource instances. Unknown keys make
this impossible — Terraform cannot create a plan that says "I will create these specific resources"
if it doesn't know what those resources are until apply.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using computed resource attributes as for_each keys** — random, UUID, computed IDs are always unknown.
- **Using `count` to work around this** — valid, but then you lose for_each's stable addressing.
- **Confusing known-at-plan-time with known-at-init-time** — variables are always known at plan time.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 16 — complex-dependency-debug
# ─────────────────────────────────────────────────────────────────────────────
def _level_16_complex_dependency_debug():
    return {
        "module": MODULE,
        "slug": "level-16-complex-dependency-debug",
        "mission": {
            "name": "Missing Link in the Chain",
            "description": (
                "A chain of four resources (A→B→C→D) exists, where D references A's output. "
                "But resource A (`local_file.base`) is not declared in the config — "
                "only B, C, and D are. Fix by adding the missing A resource declaration."
            ),
            "objective": "Add the missing `local_file.base` resource declaration so the dependency chain is complete.",
            "xp": 325,
            "difficulty": "advanced",
            "expected_time": "25m",
            "concepts": ["dependency chain debugging", "resource declarations", "implicit dependencies"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Chain: A (base) -> B (processed) -> C (enriched) -> D (final)
# Bug: local_file.base (A) is not declared — only B, C, D exist.

resource "local_file" "processed" {
  # B depends on A
  content  = "processed: ${local_file.base.content}"
  filename = "${path.module}/processed.txt"
}

resource "local_file" "enriched" {
  # C depends on B
  content  = "enriched: ${local_file.processed.content}"
  filename = "${path.module}/enriched.txt"
}

resource "local_file" "final" {
  # D depends on C and references A
  content  = "final: ${local_file.enriched.content} (base was: ${local_file.base.filename})"
  filename = "${path.module}/final.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Chain: A (base) -> B (processed) -> C (enriched) -> D (final)

resource "local_file" "base" {
  content  = "base content"
  filename = "${path.module}/base.txt"
}

resource "local_file" "processed" {
  content  = "processed: ${local_file.base.content}"
  filename = "${path.module}/processed.txt"
}

resource "local_file" "enriched" {
  content  = "enriched: ${local_file.processed.content}"
  filename = "${path.module}/enriched.txt"
}

resource "local_file" "final" {
  content  = "final: ${local_file.enriched.content} (base was: ${local_file.base.filename})"
  filename = "${path.module}/final.txt"
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform validate`. Multiple errors report references to `local_file.base` which is undeclared.",
            "Follow the dependency chain: `processed` depends on `base`, `enriched` depends on `processed`, `final` depends on `enriched` and `base`. The missing link is `base`.",
            "Add a `resource \"local_file\" \"base\"` block with a `content` and `filename` attribute to complete the chain.",
        ],
        "debrief": """\
# Missing Link in the Chain

## What Was Broken
`local_file.base` was referenced by both `local_file.processed` and `local_file.final`,
but the resource was never declared. Terraform reported multiple undeclared resource errors.

## The Fix
Add the missing resource:
```hcl
resource "local_file" "base" {
  content  = "base content"
  filename = "${path.module}/base.txt"
}
```

## Debugging Dependency Chains
1. Run `terraform validate` — it lists all undeclared references
2. Map out the dependency graph manually for complex chains
3. Use `terraform graph | dot -Tsvg > graph.svg` to visualize

## Why It Matters
When refactoring configurations, resources are sometimes accidentally deleted or moved.
`terraform validate` catches all dangling references before any infrastructure changes are made.
""",
        "common_mistakes": """\
# Common Mistakes

- **Accidentally deleting a resource that others depend on** — always search for references before removing a resource.
- **Missing resource in a module** — if a resource was moved to a module, the root config needs to access it via module outputs.
- **Confusing `depends_on` with data references** — attribute references create implicit dependencies; `depends_on` is for non-attributional dependencies.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 17 — type-mismatch-deep
# ─────────────────────────────────────────────────────────────────────────────
def _level_17_type_mismatch_deep():
    return {
        "module": MODULE,
        "slug": "level-17-type-mismatch-deep",
        "mission": {
            "name": "Type Conversion Tangle",
            "description": (
                "A local value uses `tolist(tomap([\"a\",\"b\",\"c\"]))` — converting a list to a map "
                "requires key-value pairs, not a plain list. This causes a type conversion error."
            ),
            "objective": "Fix the function chain to correctly create a list of strings without invalid type conversions.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["type conversion errors", "tolist", "tomap", "type system"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Bug: tomap() expects a map or object, not a list.
# tolist(tomap(["a","b","c"])) is a double type error:
# 1. tomap(["a","b","c"]) fails — can't make a map from a plain list
# 2. Even if it worked, tolist(map) would then fail

locals {
  items = tolist(tomap(["a", "b", "c"]))
}

resource "local_file" "type_test" {
  content  = join(", ", local.items)
  filename = "${path.module}/items.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
locals {
  items = tolist(["a", "b", "c"])
}

resource "local_file" "type_test" {
  content  = join(", ", local.items)
  filename = "${path.module}/items.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error reports a type mismatch — `tomap()` cannot convert a list of strings to a map.",
            "`tomap()` requires a map or object as input — not a list. A list of strings `[\"a\",\"b\",\"c\"]` cannot be converted to a map because there are no keys.",
            "If you just want a list of strings, use `tolist([\"a\", \"b\", \"c\"])` directly — no `tomap()` needed.",
        ],
        "debrief": """\
# Type Conversion Tangle

## What Was Broken
`tomap([\"a\",\"b\",\"c\"])` cannot convert a list to a map because there are no keys.
A map requires key-value pairs: `{key = value}`.

## The Fix
```hcl
locals {
  items = tolist(["a", "b", "c"])
}
```
`tolist()` on a literal list is valid (and often redundant, as the list is already a list).

## Type Conversion Functions
| Function | Input → Output |
|---|---|
| `tolist(list)` | tuple/set → list |
| `toset(list)` | list/tuple → set |
| `tomap(map)` | object → map |
| `tostring(value)` | primitive → string |

## Why It Matters
Type conversion errors are caught at validate time. Understanding what each function accepts
saves trial-and-error debugging.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `tomap()` on lists** — maps require keys; lists don't have them.
- **Unnecessary type conversions** — `tolist([\"a\",\"b\"])` is the same as `[\"a\",\"b\"]` in most contexts.
- **Confusing `tomap()` with `zipmap()`** — use `zipmap(keys, values)` to build a map from two lists.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 18 — crash-log-analysis
# ─────────────────────────────────────────────────────────────────────────────
def _level_18_crash_log_analysis():
    return {
        "module": MODULE,
        "slug": "level-18-crash-log-analysis",
        "mission": {
            "name": "Negative Count Crash",
            "description": (
                "A resource uses `count = -1`, which is an invalid value. "
                "Terraform rejects negative counts with a clear error. Fix by setting `count = 1`."
            ),
            "objective": "Change `count = -1` to `count = 1` to produce a valid configuration.",
            "xp": 350,
            "difficulty": "advanced",
            "expected_time": "30m",
            "concepts": ["terraform error patterns", "count constraints", "invalid values"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Bug: count = -1 is not valid — count must be a non-negative integer
resource "local_file" "items" {
  count    = -1
  content  = "item ${count.index}"
  filename = "${path.module}/item-${count.index}.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "items" {
  count    = 1
  content  = "item ${count.index}"
  filename = "${path.module}/item-${count.index}.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says the `count` value must be a non-negative integer, but `-1` is negative.",
            "Terraform requires `count` to be a whole number that is zero or greater. A count of `-1` has no meaning — you can't create negative resources.",
            "Change `count = -1` to `count = 1` to create exactly one instance.",
        ],
        "debrief": """\
# Negative Count Crash

## What Was Broken
`count = -1` is an invalid value. Terraform's `count` meta-argument must be a non-negative
integer (0 or greater).

## The Fix
```hcl
count = 1
```

## count Value Rules
| Value | Result |
|---|---|
| `0` | No instances created (resource is "disabled") |
| `1` | One instance |
| `N` | N instances (indexes 0 to N-1) |
| `-1` | Invalid — error |
| Unknown | Invalid at plan time — error |

## Reading Terraform Error Patterns
Terraform's error messages for invalid values always include:
1. The attribute that has the invalid value
2. The constraint that was violated
3. Sometimes a suggestion for the correct value

## Why It Matters
Negative counts and similar invalid values are typically introduced by:
- Bug in a calculation: `var.scale - var.reserved` going negative
- Wrong variable default
- Copy-paste error

Always validate calculated `count` values are non-negative before using them.
""",
        "common_mistakes": """\
# Common Mistakes

- **Calculated count going negative** — add a `max(0, calculated_value)` guard.
- **Using `-1` as "disable" sentinel** — use `count = 0` to disable a resource.
- **Confusing `count.index` range** — with `count = N`, valid indexes are `0` to `N-1`.
""",
    }


if __name__ == "__main__":
    build()
