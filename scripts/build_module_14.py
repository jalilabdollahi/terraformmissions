#!/usr/bin/env python3
"""Module 14 — Performance & Scale (15 levels, Expert)."""
from __future__ import annotations

from scripts.build_utils import (
    RANDOM_ONLY_TF,
    LOCAL_ONLY_TF,
    print_done,
    validate_tf_plan,
    validate_custom,
    write_level,
)

MODULE = "module-14-performance"


def build() -> int:
    levels = [
        _level_01_parallelism_tuning(),
        _level_02_targeted_operations(),
        _level_03_refresh_false(),
        _level_04_refresh_only_mode(),
        _level_05_state_partition(),
        _level_06_module_splitting(),
        _level_07_large_for_each(),
        _level_08_plan_out_file(),
        _level_09_plan_security(),
        _level_10_provider_caching(),
        _level_11_lazy_evaluation(),
        _level_12_modular_monorepo(),
        _level_13_cross_team_state(),
        _level_14_workspace_scaling(),
        _level_15_ci_cd_performance(),
    ]
    for lvl in levels:
        write_level(lvl)
    print_done(MODULE, len(levels))
    return len(levels)


# ─────────────────────────────────────────────────────────────────────────────
# Level 1 — parallelism-tuning
# ─────────────────────────────────────────────────────────────────────────────
def _level_01_parallelism_tuning():
    return {
        "module": MODULE,
        "slug": "level-1-parallelism-tuning",
        "mission": {
            "name": "Parallelism Tuning",
            "description": (
                "A config was written to create 10 random_string resources for load testing, "
                "but someone accidentally set count = 0, creating nothing. The inline comment "
                "also gives wrong advice about -parallelism. Fix the count and understand why "
                "parallelism matters for large configs."
            ),
            "objective": "Fix the resource count so all 10 random_string resources are created. terraform apply must succeed.",
            "xp": 300,
            "difficulty": "expert",
            "expected_time": "22m",
            "concepts": ["-parallelism flag", "resource count", "apply performance"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
# Performance tip (WRONG): Use -parallelism=0 to disable parallel operations
# for large configs to avoid provider rate-limiting.
# (The correct flag is -parallelism=N where N > 0; setting it to 0 is invalid.)

# BUG: count is 0 — no resources are created at all.
resource "random_string" "tokens" {
  count   = 0
  length  = 16
  special = false
}

output "token_count" {
  value = length(random_string.tokens[*].result)
}
""",
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
# Performance tip (CORRECT): Use -parallelism=10 to control how many resource
# operations run concurrently. Default is 10. For provider rate-limiting
# scenarios, lower it (e.g. -parallelism=5). Never use 0 — it is invalid.

resource "random_string" "tokens" {
  count   = 10
  length  = 16
  special = false
}

output "token_count" {
  value = length(random_string.tokens[*].result)
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -parallelism=10 -no-color -input=false 2>&1; then
    echo "FAIL: terraform apply failed"
    exit 1
fi

COUNT=$(terraform output -raw token_count 2>/dev/null || echo "0")
if [[ "$COUNT" == "10" ]]; then
    echo "PASS: 10 random_string resources created with parallelism=10"
    exit 0
fi
echo "FAIL: expected token_count=10, got $COUNT"
exit 1
"""),
        "hints": [
            "Run `terraform plan` and look at how many resources will be created. The number should be 10 — is it? Inspect the `count` argument in the resource block.",
            "The `count` argument is set to `0`. Terraform will create exactly 0 resources. Change it to `10` to create all 10 resources. Also read the comment about -parallelism — `=0` is invalid; use a positive integer like `=10`.",
            "Change `count = 0` to `count = 10`. Re-run `terraform plan` — it should now show 10 resources to add. The validate script runs apply with `-parallelism=10`.",
        ],
        "debrief": """\
# Parallelism Tuning

## What Was Broken
The `count` argument was set to `0`, so Terraform would plan to create zero resources — the
config was effectively a no-op. Additionally, an inline comment gave dangerously wrong advice
about the `-parallelism` flag (suggesting `=0`, which Terraform rejects as invalid).

## The Fix
- Change `count = 0` to `count = 10`
- Correct understanding: `-parallelism=N` must be a positive integer. The default is 10.

## Why -parallelism Matters
For large configs with hundreds of resources, Terraform's default parallelism of 10 may be
too aggressive for providers with strict API rate limits (e.g. cloud APIs that throttle
concurrent requests). Lower it to reduce concurrent operations. For local or fast providers,
increasing it speeds up apply significantly.

```bash
# Reduce for rate-limited providers
terraform apply -parallelism=5

# Increase for fast local providers
terraform apply -parallelism=20
```

## Key Takeaway
Always verify resource counts in configs before apply. A `count = 0` is syntactically valid
but silently creates nothing. The `-parallelism` flag controls concurrency; never set it to 0.
""",
        "common_mistakes": """\
# Common Mistakes

- **Setting -parallelism=0** — this is invalid and Terraform will error. Minimum useful value is 1.
- **Not checking count before apply** — `count = 0` is valid HCL and silently creates nothing.
- **Confusing -parallelism with -refresh** — they control different phases of the Terraform workflow.
- **Over-tuning parallelism** — very high values can hit provider API rate limits and cause flaky applies.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 2 — targeted-operations
# ─────────────────────────────────────────────────────────────────────────────
def _level_02_targeted_operations():
    return {
        "module": MODULE,
        "slug": "level-2-targeted-operations",
        "mission": {
            "name": "Targeted Operations",
            "description": (
                "Three resources A, B, and C exist in the config. C depends on A. "
                "The config is broken because resource C references the wrong attribute of A. "
                "Fix the attribute reference so the dependency chain is correct and both a "
                "targeted apply of A and a full apply succeed."
            ),
            "objective": "Fix the attribute reference in resource C so that `terraform apply -target` and then `terraform apply` both succeed.",
            "xp": 300,
            "difficulty": "expert",
            "expected_time": "22m",
            "concepts": ["-target flag", "dependency awareness", "resource attributes"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
# Resource A — generates a random ID
resource "random_string" "resource_a" {
  length  = 8
  special = false
  upper   = false
}

# Resource B — independent resource
resource "random_string" "resource_b" {
  length  = 8
  special = false
  upper   = false
}

# Resource C — depends on A, but references the WRONG attribute.
# random_string does not have an attribute called "id". Use "result".
resource "random_string" "resource_c" {
  length  = 12
  special = false
  upper   = false
  keepers = {
    parent_value = random_string.resource_a.id
  }
}

output "a_result" { value = random_string.resource_a.result }
output "b_result" { value = random_string.resource_b.result }
output "c_result" { value = random_string.resource_c.result }
""",
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
resource "random_string" "resource_a" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "resource_b" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "resource_c" {
  length  = 12
  special = false
  upper   = false
  keepers = {
    parent_value = random_string.resource_a.result
  }
}

output "a_result" { value = random_string.resource_a.result }
output "b_result" { value = random_string.resource_b.result }
output "c_result" { value = random_string.resource_c.result }
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# First apply only resource_a with -target
if ! terraform apply -auto-approve -target=random_string.resource_a -no-color -input=false 2>&1; then
    echo "FAIL: targeted apply of resource_a failed"
    exit 1
fi

# Then apply the full config
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: full terraform apply failed"
    exit 1
fi

echo "PASS: targeted apply and full apply both succeeded"
exit 0
"""),
        "hints": [
            "Run `terraform validate`. The error will tell you which attribute does not exist on `random_string`. Read the schema for `random_string` in the Terraform Registry — what attributes does it expose?",
            "The `random_string` resource exposes a `result` attribute (the generated string). The `id` attribute is not a valid attribute on this resource. The error message confirms this.",
            "In the `keepers` block of `resource_c`, change `random_string.resource_a.id` to `random_string.resource_a.result`. Then run `terraform validate` again to confirm.",
        ],
        "debrief": """\
# Targeted Operations

## What Was Broken
Resource C's `keepers` map referenced `random_string.resource_a.id`, but the `random_string`
resource type does not expose an `id` attribute — it exposes `result`. This caused a validation
error that prevented any operation from running.

## The Fix
Change `random_string.resource_a.id` → `random_string.resource_a.result`.

## Why -target Matters
`terraform apply -target=<address>` lets you apply only a specific resource (and its dependencies).
This is powerful for:
- Unblocking a single resource without touching others
- Debugging a specific resource in a large config
- Incremental apply in complex dependency graphs

**Warning:** Using `-target` regularly leaves state partially applied and can cause drift from
the config. Use it as a debugging and emergency tool, not a standard workflow.

## Key Takeaway
Always verify resource attribute names against the provider schema. `terraform validate` catches
these before a plan is attempted. Use `-target` tactically for targeted debugging.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using .id when .result is the correct attribute** — always check provider documentation.
- **Over-relying on -target** — partial applies can create state drift that accumulates over time.
- **Forgetting that -target includes dependencies** — Terraform will also apply any dependencies of the targeted resource.
- **Not running a full apply after -target** — always follow up with an untargeted apply to converge the full config.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 3 — refresh-false
# ─────────────────────────────────────────────────────────────────────────────
def _level_03_refresh_false():
    return {
        "module": MODULE,
        "slug": "level-3-refresh-false",
        "mission": {
            "name": "The Stale State Problem",
            "description": (
                "A resource was configured with `lifecycle { ignore_changes = all }` which masks "
                "a real configuration issue. The broken config uses ignore_changes incorrectly — "
                "it hides ALL changes instead of only the specific attribute that should be ignored. "
                "Fix the lifecycle block to only ignore the `keepers` attribute, then verify plan "
                "with -refresh=false succeeds."
            ),
            "objective": "Fix lifecycle ignore_changes to only ignore the `keepers` attribute, then verify plan with -refresh=false succeeds.",
            "xp": 325,
            "difficulty": "expert",
            "expected_time": "25m",
            "concepts": ["-refresh=false flag", "stale state", "lifecycle ignore_changes"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
# This resource uses ignore_changes = all which is an anti-pattern.
# It hides ALL configuration drift including actual bugs.
# Fix: only ignore the 'keepers' attribute which is intentionally externally managed.
resource "random_string" "cached_token" {
  length  = 16
  special = false

  lifecycle {
    ignore_changes = all
  }
}

output "token" {
  value = random_string.cached_token.result
}
""",
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
resource "random_string" "cached_token" {
  length  = 16
  special = false

  lifecycle {
    ignore_changes = [keepers]
  }
}

output "token" {
  value = random_string.cached_token.result
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# First apply to create the resource
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: initial apply failed"
    exit 1
fi

# Plan with -refresh=false should succeed (exit 0 = no changes, exit 2 = changes, exit 1 = error)
terraform plan -refresh=false -detailed-exitcode -no-color -input=false 2>&1
CODE=$?
if [[ $CODE -eq 0 ]] || [[ $CODE -eq 2 ]]; then
    echo "PASS: plan -refresh=false succeeded"
    exit 0
fi
echo "FAIL: plan -refresh=false returned error (exit $CODE)"
exit 1
"""),
        "hints": [
            "Run `terraform validate` — the config is syntactically valid, but `ignore_changes = all` is a code smell. This tells Terraform to NEVER update this resource, regardless of what configuration drift occurs. It masks real problems.",
            "The goal is to only ignore the `keepers` attribute (which may be managed externally) while still allowing Terraform to detect and correct other attribute drift.",
            "Change `ignore_changes = all` to `ignore_changes = [keepers]`. The list form accepts specific attribute names. After the fix, plan with `-refresh=false` should succeed.",
        ],
        "debrief": """\
# The Stale State Problem

## What Was Broken
`lifecycle { ignore_changes = all }` is a blunt instrument that tells Terraform to never modify
a resource regardless of what drifts. While useful in rare edge cases (e.g. externally managed
resources), it is almost always an anti-pattern because it prevents Terraform from enforcing
desired state and silently hides real configuration errors.

## The Fix
Replace `ignore_changes = all` with `ignore_changes = [keepers]` to only ignore the specific
attribute that is legitimately managed outside Terraform.

## -refresh=false Explained
`terraform plan -refresh=false` skips the state refresh step (reading real infrastructure state).
Use cases:
- **Speed**: skipping refresh on large configs with hundreds of resources
- **Offline/air-gapped environments**: no API access during planning
- **Using a known-good state snapshot**: avoid re-querying APIs when state is known accurate

**Risk:** If real infrastructure has drifted since last refresh, `-refresh=false` will miss it.
Always understand whether your state is trustworthy before using this flag.

## Key Takeaway
`ignore_changes = all` is a last resort. Always prefer `ignore_changes = [specific_attribute]`
to maintain Terraform's ability to detect and correct real drift.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using ignore_changes = all permanently** — creates "zombie" resources that drift silently.
- **Using -refresh=false as the default** — leads to stale state diverging from reality undetected.
- **Not documenting why ignore_changes is used** — always add a comment explaining the justification.
- **Confusing -refresh=false with -refresh-only** — these are completely different operations.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 4 — refresh-only-mode
# ─────────────────────────────────────────────────────────────────────────────
def _level_04_refresh_only_mode():
    return {
        "module": MODULE,
        "slug": "level-4-refresh-only-mode",
        "mission": {
            "name": "Refresh-Only Mode",
            "description": (
                "A resource is configured without a lifecycle block to prevent unintended recreation. "
                "The validate script applies the config and then uses -refresh-only to update state. "
                "The broken config is missing the lifecycle block that prevents resource recreation "
                "when keepers change. Without it, any keeper change causes a destroy-and-recreate."
            ),
            "objective": "Add a lifecycle block with ignore_changes = [keepers] to prevent recreation on keeper drift, then verify refresh-only works.",
            "xp": 325,
            "difficulty": "expert",
            "expected_time": "25m",
            "concepts": ["-refresh-only mode", "lifecycle ignore_changes", "drift detection"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
# This resource will be recreated (destroyed + created) if keepers change.
# In production, this could mean regenerating a secret token unexpectedly.
# Fix: add a lifecycle block with ignore_changes = [keepers] to prevent this.
resource "random_string" "api_token" {
  length  = 32
  special = false
  keepers = {
    version = "v1"
  }
}

output "api_token_value" {
  value     = random_string.api_token.result
  sensitive = true
}
""",
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
resource "random_string" "api_token" {
  length  = 32
  special = false
  keepers = {
    version = "v1"
  }

  lifecycle {
    ignore_changes = [keepers]
  }
}

output "api_token_value" {
  value     = random_string.api_token.result
  sensitive = true
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# Initial apply
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: initial apply failed"
    exit 1
fi

# Run refresh-only to update state without making infrastructure changes
terraform apply -refresh-only -auto-approve -no-color -input=false 2>&1
CODE=$?
if [[ $CODE -eq 0 ]]; then
    echo "PASS: refresh-only apply succeeded"
    exit 0
fi
echo "FAIL: refresh-only apply failed (exit $CODE)"
exit 1
"""),
        "hints": [
            "Run `terraform plan`. Notice that changing `keepers` in the config would force replacement of the resource (destroy + create). In production this destroys a live secret token — catastrophic.",
            "The `lifecycle` block can contain `ignore_changes = [keepers]` to tell Terraform: the keepers map may change, but do not recreate the resource because of keeper changes alone.",
            "Add a `lifecycle { ignore_changes = [keepers] }` block inside the `random_string` resource. The validate script will then apply and run `terraform apply -refresh-only` to verify state sync.",
        ],
        "debrief": """\
# Refresh-Only Mode

## What Was Broken
The resource lacked a `lifecycle { ignore_changes = [keepers] }` block. Without it, any change
to the `keepers` map — even an automated process bumping a version key — would cause Terraform
to destroy and recreate the resource. For secrets and tokens, this is catastrophic in production.

## The Fix
Add `lifecycle { ignore_changes = [keepers] }` to stabilize the resource against keeper changes.

## -refresh-only Explained
`terraform apply -refresh-only` updates the Terraform state file to match the current real-world
state WITHOUT making any infrastructure changes. Use it to:
- Reconcile state drift after manual out-of-band changes you want to accept
- Update state after infrastructure changes made directly (e.g. console changes)
- Prepare an accurate state snapshot before a follow-up convergence apply

The workflow: `apply -refresh-only` (accept drift) → review → `apply` (converge config).

**Difference from terraform refresh (deprecated):**
`terraform refresh` was a standalone command that did the same thing. It was deprecated in
Terraform 1.5 in favor of `apply -refresh-only`, which shows a preview before committing.

## Key Takeaway
`-refresh-only` is a safe way to accept reality into your state. Combined with careful
`lifecycle` rules, it gives you precise control over when resources are recreated.
""",
        "common_mistakes": """\
# Common Mistakes

- **Forgetting lifecycle on tokens/secrets** — any keeper change forces recreation without it.
- **Confusing -refresh-only with terraform refresh** — `terraform refresh` is deprecated; use `-refresh-only`.
- **Not reviewing the refresh-only plan** — always review what drift will be accepted before applying.
- **Using -refresh-only instead of fixing drift** — it accepts drift into state; still update config to match reality.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 5 — state-partition
# ─────────────────────────────────────────────────────────────────────────────
def _level_05_state_partition():
    return {
        "module": MODULE,
        "slug": "level-5-state-partition",
        "mission": {
            "name": "State Partitioning",
            "description": (
                "A large config has been split into two: config-a (infrastructure) and config-b "
                "(application). Config-b reads config-a's state via terraform_remote_state, but "
                "references the wrong output key. Fix the output key reference so config-b can "
                "correctly consume config-a's outputs."
            ),
            "objective": "Fix the wrong output key in config-b's remote_state reference so both configs can be applied.",
            "xp": 350,
            "difficulty": "expert",
            "expected_time": "28m",
            "concepts": ["state partitioning", "terraform_remote_state", "cross-config outputs"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "config-a/terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  backend "local" {
    path = "terraform-a.tfstate"
  }
}
""",
            "config-a/main.tf": """\
resource "random_string" "infra_id" {
  length  = 8
  special = false
  upper   = false
}

output "infrastructure_id" {
  value = random_string.infra_id.result
}
""",
            "config-b/terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  backend "local" {
    path = "terraform-b.tfstate"
  }
}
""",
            "config-b/main.tf": """\
data "terraform_remote_state" "infra" {
  backend = "local"
  config = {
    path = "../config-a/terraform-a.tfstate"
  }
}

# BUG: The output key is wrong. Config-a exports "infrastructure_id", not "infra_id".
resource "random_string" "app_id" {
  length  = 12
  special = false
  upper   = false
  keepers = {
    infra = data.terraform_remote_state.infra.outputs.infra_id
  }
}

output "app_id" {
  value = random_string.app_id.result
}
""",
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "config-a/terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  backend "local" {
    path = "terraform-a.tfstate"
  }
}
""",
            "config-a/main.tf": """\
resource "random_string" "infra_id" {
  length  = 8
  special = false
  upper   = false
}

output "infrastructure_id" {
  value = random_string.infra_id.result
}
""",
            "config-b/terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  backend "local" {
    path = "terraform-b.tfstate"
  }
}
""",
            "config-b/main.tf": """\
data "terraform_remote_state" "infra" {
  backend = "local"
  config = {
    path = "../config-a/terraform-a.tfstate"
  }
}

resource "random_string" "app_id" {
  length  = 12
  special = false
  upper   = false
  keepers = {
    infra = data.terraform_remote_state.infra.outputs.infrastructure_id
  }
}

output "app_id" {
  value = random_string.app_id.result
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# Apply config-a first to create their state file
cd config-a
terraform init -no-color -input=false 2>&1
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: config-a apply failed"
    exit 1
fi
cd ..

# Apply config-b which reads config-a's state
cd config-b
terraform init -no-color -input=false 2>&1
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: config-b apply failed — check remote state output key"
    exit 1
fi
cd ..

echo "PASS: both configs applied successfully with correct remote state reference"
exit 0
"""),
        "hints": [
            "Run `terraform init && terraform plan` inside config-b/. The error references an output key that does not exist in config-a's state. Look at config-a/main.tf — what is the actual output name?",
            "Config-a defines one output: `infrastructure_id`. Config-b references `infra_id` — a shorter, different name. These must match exactly.",
            "In config-b/main.tf, change `data.terraform_remote_state.infra.outputs.infra_id` to `data.terraform_remote_state.infra.outputs.infrastructure_id`.",
        ],
        "debrief": """\
# State Partitioning

## What Was Broken
Config-b referenced `data.terraform_remote_state.infra.outputs.infra_id`, but config-a exports
its output as `infrastructure_id` — a different key name. This causes a runtime error when
config-b tries to access a non-existent key from the remote state.

## The Fix
Update the reference in config-b to use the correct output key: `infrastructure_id`.

## State Partitioning Benefits
Large Terraform configs are split into partitions (separate state files) for:
- **Blast radius reduction** — mistakes in the app layer cannot destroy core infrastructure
- **Faster operations** — each partition has fewer resources to plan and apply
- **Team autonomy** — different teams own different state partitions with independent lock cycles
- **Reduced state lock contention** — concurrent operations in different partitions don't block each other

## Output Contracts
`terraform_remote_state` creates an implicit API contract: the output key names. Treat them as
public, versioned API surface. Never rename outputs without coordinating with all consumers.

## Key Takeaway
Treat outputs from shared state as a public API. Document them, version them, and avoid renaming
them without updating all consumers. Consider using a wrapper module to abstract the contract.
""",
        "common_mistakes": """\
# Common Mistakes

- **Mismatched output key names** — the most common error when consuming remote state.
- **Forgetting to apply config-a before config-b** — config-b needs a real state file to read from.
- **Using relative paths in remote_state config** — paths are relative to the working directory at apply time.
- **Circular remote_state references** — config-a must never read config-b's state if config-b reads config-a.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 6 — module-splitting
# ─────────────────────────────────────────────────────────────────────────────
def _level_06_module_splitting():
    return {
        "module": MODULE,
        "slug": "level-6-module-splitting",
        "mission": {
            "name": "Module Splitting with moved Blocks",
            "description": (
                "A monolithic main.tf with 5 resources has been refactored into a child module. "
                "However, the `moved` blocks are missing from the root config, so Terraform will "
                "plan to destroy all 5 original resources and recreate them inside the module. "
                "Add the missing moved blocks to make the refactor zero-destructive."
            ),
            "objective": "Add moved blocks for all 5 resources so that `terraform plan` shows no destroy operations.",
            "xp": 350,
            "difficulty": "expert",
            "expected_time": "28m",
            "concepts": ["moved blocks", "module splitting", "zero-downtime refactor"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
# These 5 resources were in the root module and have been moved to modules/strings/.
# Missing: moved blocks to tell Terraform the resources relocated.
# Without moved blocks, Terraform plans to destroy originals and recreate inside the module.

module "strings" {
  source = "./modules/strings"
}

output "all_results" {
  value = module.strings.results
}
""",
            "modules/strings/terraform.tf": RANDOM_ONLY_TF,
            "modules/strings/main.tf": """\
resource "random_string" "token_a" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "token_b" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "token_c" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "token_d" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "token_e" {
  length  = 8
  special = false
  upper   = false
}

output "results" {
  value = [
    random_string.token_a.result,
    random_string.token_b.result,
    random_string.token_c.result,
    random_string.token_d.result,
    random_string.token_e.result,
  ]
}
""",
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
module "strings" {
  source = "./modules/strings"
}

# moved blocks: tell Terraform the resources relocated from root to the module
moved {
  from = random_string.token_a
  to   = module.strings.random_string.token_a
}

moved {
  from = random_string.token_b
  to   = module.strings.random_string.token_b
}

moved {
  from = random_string.token_c
  to   = module.strings.random_string.token_c
}

moved {
  from = random_string.token_d
  to   = module.strings.random_string.token_d
}

moved {
  from = random_string.token_e
  to   = module.strings.random_string.token_e
}

output "all_results" {
  value = module.strings.results
}
""",
            "modules/strings/terraform.tf": RANDOM_ONLY_TF,
            "modules/strings/main.tf": """\
resource "random_string" "token_a" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "token_b" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "token_c" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "token_d" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "token_e" {
  length  = 8
  special = false
  upper   = false
}

output "results" {
  value = [
    random_string.token_a.result,
    random_string.token_b.result,
    random_string.token_c.result,
    random_string.token_d.result,
    random_string.token_e.result,
  ]
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

terraform init -no-color -input=false 2>&1

# Apply to create resources (in a real scenario, state would already exist)
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: apply failed"
    exit 1
fi

# Now plan — with correct moved blocks there should be no destroy
PLAN_OUT=$(terraform plan -detailed-exitcode -no-color -input=false 2>&1)
PLAN_CODE=$?

if echo "$PLAN_OUT" | grep -q "will be destroyed"; then
    echo "FAIL: plan contains destroy operations — moved blocks may be missing or wrong"
    exit 1
fi

if [[ $PLAN_CODE -eq 0 ]] || [[ $PLAN_CODE -eq 2 ]]; then
    echo "PASS: plan has no destroy operations — module splitting is zero-destructive"
    exit 0
fi

echo "FAIL: plan returned error"
exit 1
"""),
        "hints": [
            "Run `terraform plan`. You will see 5 destroy + 5 create pairs — one for each resource being relocated into the module. Terraform doesn't know they're the same resources without `moved` blocks.",
            "The `moved` block syntax is: `moved { from = random_string.token_a  to = module.strings.random_string.token_a }`. You need one for each of the 5 resources (token_a through token_e).",
            "Add 5 `moved` blocks in main.tf, mapping each root-level address (e.g. `random_string.token_a`) to its new module address (e.g. `module.strings.random_string.token_a`). Re-run plan — no destroys should appear.",
        ],
        "debrief": """\
# Module Splitting with moved Blocks

## What Was Broken
When resources are moved into a module without `moved` blocks, Terraform sees the old resource
addresses as "to be deleted" and the new module addresses as "to be created". This results in
a destroy + recreate cycle — potentially catastrophic for stateful resources in production.

## The Fix
Add one `moved` block per relocated resource, mapping the old address to the new module address.

## moved Block Syntax
```hcl
moved {
  from = random_string.token_a
  to   = module.strings.random_string.token_a
}
```

The `from` address is where the resource WAS. The `to` address is where it IS NOW.

## When to Use moved Blocks
- Moving resources into or out of modules
- Renaming resources within a module
- Changing `for_each` keys (causes address changes)
- Splitting or merging config root modules (as an alternative to `terraform state mv`)

## Key Takeaway
`moved` blocks are the safe, declarative, reviewable way to refactor Terraform configs without
destroying infrastructure. They are the preferred alternative to imperative `terraform state mv`.
Once all team members have applied the change, you can remove them.
""",
        "common_mistakes": """\
# Common Mistakes

- **Forgetting moved blocks during refactoring** — the leading cause of accidental destroy in module splits.
- **Wrong module address format** — use `module.<name>.<type>.<label>`, not just `<type>.<label>`.
- **Removing moved blocks too early** — wait until all team members have run the refactored plan.
- **Using moved blocks for cross-state moves** — moved only works within the same state file; use state mv for cross-state.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 7 — large-for-each
# ─────────────────────────────────────────────────────────────────────────────
def _level_07_large_for_each():
    return {
        "module": MODULE,
        "slug": "level-7-large-for-each",
        "mission": {
            "name": "Large for_each Optimization",
            "description": (
                "A config uses for_each over a map of 20 entries to create random_string resources. "
                "The map values have the wrong type — they should be numbers (the desired string length) "
                "but are provided as strings. Fix the map value types so the for_each plan succeeds."
            ),
            "objective": "Fix the map value types in the variable so that `terraform plan` succeeds for all 20 resources.",
            "xp": 350,
            "difficulty": "expert",
            "expected_time": "28m",
            "concepts": ["large for_each", "type constraints", "variable validation"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "variables.tf": """\
# BUG: The map values are strings, but random_string.length expects a number.
# Fix: change type to map(number) and remove quotes from all values.
variable "token_lengths" {
  type = map(string)
  default = {
    token_01 = "8"
    token_02 = "10"
    token_03 = "12"
    token_04 = "8"
    token_05 = "16"
    token_06 = "8"
    token_07 = "10"
    token_08 = "12"
    token_09 = "8"
    token_10 = "16"
    token_11 = "8"
    token_12 = "10"
    token_13 = "12"
    token_14 = "8"
    token_15 = "16"
    token_16 = "8"
    token_17 = "10"
    token_18 = "12"
    token_19 = "8"
    token_20 = "16"
  }
}
""",
            "main.tf": """\
resource "random_string" "tokens" {
  for_each = var.token_lengths
  length   = each.value
  special  = false
  upper    = false
}

output "token_results" {
  value = { for k, v in random_string.tokens : k => v.result }
}
""",
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "variables.tf": """\
variable "token_lengths" {
  type = map(number)
  default = {
    token_01 = 8
    token_02 = 10
    token_03 = 12
    token_04 = 8
    token_05 = 16
    token_06 = 8
    token_07 = 10
    token_08 = 12
    token_09 = 8
    token_10 = 16
    token_11 = 8
    token_12 = 10
    token_13 = 12
    token_14 = 8
    token_15 = 16
    token_16 = 8
    token_17 = 10
    token_18 = 12
    token_19 = 8
    token_20 = 16
  }
}
""",
            "main.tf": """\
resource "random_string" "tokens" {
  for_each = var.token_lengths
  length   = each.value
  special  = false
  upper    = false
}

output "token_results" {
  value = { for k, v in random_string.tokens : k => v.result }
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The error is a type mismatch — `random_string.length` expects a number but is receiving a string. Look at the variable definition for `token_lengths` and the type declaration.",
            "The variable `token_lengths` is declared as `map(string)` and its values are quoted (e.g. `\"8\"`). The `length` attribute of `random_string` requires a `number`, not a `string`. Terraform does not auto-coerce in this context.",
            "Change the variable type from `map(string)` to `map(number)` AND remove the quotes from all 20 values (e.g. `token_01 = 8` not `token_01 = \"8\"`). Re-run plan.",
        ],
        "debrief": """\
# Large for_each Optimization

## What Was Broken
The `token_lengths` variable was typed as `map(string)`, but the `random_string` resource
requires its `length` attribute to be a `number`. Terraform's type system does NOT silently
coerce `"8"` (string) to `8` (number) in all attribute contexts — this causes a type constraint
error that blocks planning for ALL 20 resources.

## The Fix
- Change variable type from `map(string)` to `map(number)`
- Remove quotes from all 20 map values

## for_each at Scale
Using `for_each` over a large map is the idiomatic pattern for managing many similar resources:
- Resources are addressed by map key: `random_string.tokens["token_01"]`
- Adding/removing map entries only creates/destroys that specific resource
- `count` forces index-based addressing, causing cascading recreation when items are inserted mid-list

## Performance Consideration
For configs with hundreds of for_each resources:
- `terraform plan` time is roughly O(n) in number of resources
- Use `-parallelism` to tune apply throughput
- Consider state partitioning if the config grows beyond ~500 resources

## Key Takeaway
Always declare variable types precisely. `map(number)` vs `map(string)` is a meaningful
distinction. Validate types with `terraform validate` early in your development cycle.
""",
        "common_mistakes": """\
# Common Mistakes

- **Quoting numbers in maps** — `"8"` is a string, `8` is a number; provider attributes are type-strict.
- **Using count instead of for_each for maps** — count is index-based and causes cascade recreation.
- **Not validating variable types** — add `validation` blocks to enforce correct input ranges.
- **Large for_each with slow providers** — tune -parallelism down to avoid API rate-limit errors.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 8 — plan-out-file
# ─────────────────────────────────────────────────────────────────────────────
def _level_08_plan_out_file():
    return {
        "module": MODULE,
        "slug": "level-8-plan-out-file",
        "mission": {
            "name": "Plan File Workflow",
            "description": (
                "The config has a random_string resource where the minimum character requirements "
                "exceed the total string length, preventing the plan from succeeding. "
                "The validate workflow uses `terraform plan -out=tfplan` followed by "
                "`terraform apply tfplan`. Fix the resource attributes so the plan file workflow succeeds."
            ),
            "objective": "Fix the broken attribute values so `terraform plan -out=tfplan` succeeds, then `terraform apply tfplan` completes.",
            "xp": 300,
            "difficulty": "expert",
            "expected_time": "22m",
            "concepts": ["plan files", "-out flag", "deterministic apply"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
# BUG: min_lower + min_upper + min_numeric + min_special must be <= length.
# Here: 5 + 5 + 5 + 5 = 20, but length = 12. This is invalid.
resource "random_string" "secure_token" {
  length      = 12
  special     = true
  min_lower   = 5
  min_upper   = 5
  min_numeric = 5
  min_special = 5
}

output "token" {
  value     = random_string.secure_token.result
  sensitive = true
}
""",
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
resource "random_string" "secure_token" {
  length      = 16
  special     = true
  min_lower   = 3
  min_upper   = 3
  min_numeric = 3
  min_special = 3
}

output "token" {
  value     = random_string.secure_token.result
  sensitive = true
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# Run plan and save to file
if ! terraform plan -out=tfplan -no-color -input=false 2>&1; then
    echo "FAIL: terraform plan -out=tfplan failed"
    exit 1
fi

# Apply the saved plan file (no re-planning)
if ! terraform apply -no-color tfplan 2>&1; then
    echo "FAIL: terraform apply tfplan failed"
    exit 1
fi

echo "PASS: plan file workflow (plan -out + apply plan) succeeded"
exit 0
"""),
        "hints": [
            "Run `terraform plan`. The error is about the `random_string` constraints — the sum of minimum character requirements exceeds the total string length. What do all the min_* values add up to compared to length?",
            "The sum `min_lower(5) + min_upper(5) + min_numeric(5) + min_special(5) = 20`, but `length = 12`. The provider requires that the sum of minimums <= total length. Either increase length or reduce the minimums.",
            "Change `length = 12` to `length = 16` and set `min_lower = min_upper = min_numeric = min_special = 3` (sum = 12 <= 16). Then the plan will succeed and can be saved to a file.",
        ],
        "debrief": """\
# Plan File Workflow

## What Was Broken
The `random_string` resource had `min_lower + min_upper + min_numeric + min_special = 20`
but `length = 12`. The random provider validates that the sum of minimums does not exceed
the total length, and rejects the configuration with an error at plan time.

## The Fix
Increase `length` to `16` and reduce each minimum to `3` (total = 12 <= 16).

## Plan File Workflow
The `plan -out` / `apply <planfile>` pattern is critical for production safety:

```bash
# Step 1: Generate and save plan
terraform plan -out=tfplan

# Step 2: Review the plan (audit, peer review, approval gate)
terraform show tfplan

# Step 3: Apply exactly what was reviewed
terraform apply tfplan
```

**Why it matters:**
- The apply step executes EXACTLY the saved plan — no re-planning, no surprises
- Separates the "plan reviewer" role from the "apply executor" role
- Required for CI/CD pipelines with approval gates (plan in PR, apply on merge)
- Prevents a race condition where a new commit changes the config between plan and apply

## Key Takeaway
Always use `plan -out` in automated pipelines. An unguarded `terraform apply -auto-approve`
without a saved plan re-runs planning at apply time and could pick up unexpected changes.
""",
        "common_mistakes": """\
# Common Mistakes

- **min_* values summing to more than length** — a common random_string misconfiguration that only surfaces at plan time.
- **Not using plan files in CI/CD** — allows drift between plan review and apply execution.
- **Storing plan files in unencrypted storage** — plan files can contain sensitive values in plain text.
- **Applying stale plan files** — plan files become invalid if state changes between plan and apply.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 9 — plan-security
# ─────────────────────────────────────────────────────────────────────────────
def _level_09_plan_security():
    return {
        "module": MODULE,
        "slug": "level-9-plan-security",
        "mission": {
            "name": "Plan File Security",
            "description": (
                "A config has a `random_password` resource whose generated value is exposed in "
                "an output without being marked as sensitive. This means the password appears in "
                "plain text in plan output, CI/CD logs, and terminal history. "
                "Fix: mark the output as sensitive."
            ),
            "objective": "Mark the password output as sensitive so that the plan output does NOT expose the raw value.",
            "xp": 350,
            "difficulty": "expert",
            "expected_time": "28m",
            "concepts": ["plan file security", "sensitive outputs", "secret hygiene"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
resource "random_password" "db_password" {
  length           = 20
  special          = true
  override_special = "!#$%^&*"
}

# BUG: This output exposes the raw password in plan output and CI/CD logs.
# Fix: add sensitive = true to prevent the value from appearing in output.
output "database_password" {
  value = random_password.db_password.result
}

output "password_length" {
  value = random_password.db_password.length
}
""",
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
resource "random_password" "db_password" {
  length           = 20
  special          = true
  override_special = "!#$%^&*"
}

output "database_password" {
  value     = random_password.db_password.result
  sensitive = true
}

output "password_length" {
  value = random_password.db_password.length
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

PLAN_OUTPUT=$(terraform plan -no-color -input=false 2>&1)
PLAN_CODE=$?

if [[ $PLAN_CODE -ne 0 ]] && [[ $PLAN_CODE -ne 2 ]]; then
    echo "FAIL: terraform plan failed"
    echo "$PLAN_OUTPUT"
    exit 1
fi

# Check that the plan output redacts the password with (sensitive value)
if echo "$PLAN_OUTPUT" | grep -q "(sensitive value)"; then
    echo "PASS: sensitive output is redacted in plan output"
    exit 0
fi

# Also check the output block itself shows sensitive = true
if echo "$PLAN_OUTPUT" | grep -q "sensitive"; then
    echo "PASS: sensitive marker found in plan output"
    exit 0
fi

echo "FAIL: database_password output does not appear to be marked as sensitive"
echo "$PLAN_OUTPUT"
exit 1
"""),
        "hints": [
            "Run `terraform plan`. Look at the output section — does the `database_password` output show the actual password value in plain text? In CI/CD this would be visible in build logs.",
            "The `output` block supports a `sensitive = true` argument. When set, Terraform replaces the value with `(sensitive value)` in all plan, apply, and show output.",
            "Add `sensitive = true` to the `database_password` output block. Re-run `terraform plan` and verify the password is shown as `(sensitive value)` not the raw string.",
        ],
        "debrief": """\
# Plan File Security

## What Was Broken
The `database_password` output was missing `sensitive = true`. The raw password appeared in:
- `terraform plan` terminal output (visible in CI/CD logs)
- `terraform apply` output
- Saved plan files (stored in plain text if the file is not encrypted)
- `terraform output` command output

## The Fix
Add `sensitive = true` to the `database_password` output block.

## What sensitive = true Does
- Redacts the value in plan/apply/show output (shows `(sensitive value)`)
- Prevents accidental exposure in CI/CD logs and terminal history
- Marks downstream references as sensitive automatically
- Does NOT encrypt the value in state — the state file still stores it in plain text

## Real Secret Management
`sensitive = true` is a display guard, NOT a security boundary:
- State file contains the plain text value
- Operator with state access can always read it
- For production secrets, use an external secret store:
  - HashiCorp Vault (with vault provider)
  - AWS Secrets Manager / SSM Parameter Store
  - Azure Key Vault
  - GCP Secret Manager

## Key Takeaway
Mark ALL secret outputs as `sensitive = true` as a defense-in-depth measure. But also treat
your state file as a secret — restrict access, encrypt at rest, and use a secure backend.
""",
        "common_mistakes": """\
# Common Mistakes

- **Not marking password outputs as sensitive** — they appear in CI/CD logs and terminal history.
- **Thinking sensitive = true encrypts the state** — it does not; state still has plain text values.
- **Forgetting that plan files contain sensitive data** — encrypt, restrict access, and clean up .tfplan files.
- **Reading sensitive outputs directly into config files** — use secret managers as intermediaries.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 10 — provider-caching
# ─────────────────────────────────────────────────────────────────────────────
def _level_10_provider_caching():
    return {
        "module": MODULE,
        "slug": "level-10-provider-caching",
        "mission": {
            "name": "Provider Caching",
            "description": (
                "A config uses a non-existent provider version constraint, simulating a scenario "
                "where the local provider cache has a valid version but the constraint requires "
                "a version that doesn't exist — causing a cache miss and download failure. "
                "Fix the version constraint to a valid one so `terraform init` succeeds."
            ),
            "objective": "Fix the provider version constraint so `terraform init` succeeds.",
            "xp": 325,
            "difficulty": "expert",
            "expected_time": "25m",
            "concepts": ["provider caching", "TF_PLUGIN_CACHE_DIR", "version constraints"],
        },
        "broken": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      # BUG: This version does not exist. The cache would have ~> 3.6 but not 3.99.
      # Fix: use a valid constraint like ~> 3.6
      version = "= 3.99.0"
    }
  }
}
""",
            "main.tf": """\
resource "random_string" "cached" {
  length  = 8
  special = false
}

output "result" {
  value = random_string.cached.result
}
""",
        },
        "solution": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
""",
            "main.tf": """\
resource "random_string" "cached" {
  length  = 8
  special = false
}

output "result" {
  value = random_string.cached.result
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# terraform init must succeed (meaning the version constraint is satisfiable)
if terraform init -no-color -input=false 2>&1; then
    echo "PASS: terraform init succeeded with valid provider version constraint"
    exit 0
fi
echo "FAIL: terraform init failed — version constraint may reference a non-existent version"
exit 1
"""),
        "hints": [
            "Run `terraform init`. The error says it cannot find version `3.99.0` of `hashicorp/random`. Visit registry.terraform.io/providers/hashicorp/random to see what versions exist.",
            "The constraint `= 3.99.0` requires an exact version that does not exist. A pessimistic constraint like `~> 3.6` means `>= 3.6, < 4.0` and will match available 3.6.x releases.",
            "Change `version = \"= 3.99.0\"` to `version = \"~> 3.6\"`. Run `terraform init` — it should now succeed by finding and downloading a 3.6.x version.",
        ],
        "debrief": """\
# Provider Caching

## What Was Broken
The version constraint `= 3.99.0` pins to a non-existent provider version. Terraform init
queries the registry, finds no matching version, and fails. In a provider caching scenario,
if `TF_PLUGIN_CACHE_DIR` contains version 3.6.1 but the constraint requires 3.99.0, the
cached version does not satisfy the constraint — cache miss, download attempt, failure.

## The Fix
Change to `~> 3.6` which matches the available 3.6.x line.

## TF_PLUGIN_CACHE_DIR Explained
```bash
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
mkdir -p "$TF_PLUGIN_CACHE_DIR"
terraform init
```

When a provider satisfying the constraint is in the cache directory, Terraform symlinks to it
instead of downloading. This dramatically speeds up `terraform init` in CI/CD environments.

**Requirements:**
- Cache directory must exist and be writable by the Terraform process
- Provider version in cache must satisfy the version constraint
- If constraint does not match any cached version → cache miss → fresh download

## Version Constraint Operators
| Operator | Meaning |
|---------|---------|
| `= 1.2.3` | Exact version only |
| `~> 1.2` | >= 1.2, < 2.0 (pessimistic) |
| `~> 1.2.3` | >= 1.2.3, < 1.3.0 (pessimistic patch) |
| `>= 1.2, < 2.0` | Range (explicit) |

## Key Takeaway
Use pessimistic constraints (`~>`) rather than exact pinning (`=`) for providers. Use
`.terraform.lock.hcl` for reproducibility — it records the exact version selected within
the constraint range.
""",
        "common_mistakes": """\
# Common Mistakes

- **Exact version pinning with = operator** — brittle; breaks when a version is yanked from the registry.
- **Setting TF_PLUGIN_CACHE_DIR to a read-only path** — init silently bypasses cache or fails.
- **Different constraints across configs** — leads to multiple provider versions being cached unnecessarily.
- **Not committing .terraform.lock.hcl** — without the lock file, the selected version can drift between runs.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 11 — lazy-evaluation
# ─────────────────────────────────────────────────────────────────────────────
def _level_11_lazy_evaluation():
    return {
        "module": MODULE,
        "slug": "level-11-lazy-evaluation",
        "mission": {
            "name": "Lazy Evaluation and templatefile()",
            "description": (
                "A config calls `templatefile()` inside a `for_each` loop over 10 services. "
                "The template path is wrong — it points to a non-existent subdirectory — "
                "so the plan fails for all 10 resources simultaneously. "
                "Fix the template path to the correct relative location."
            ),
            "objective": "Fix the templatefile() path so `terraform plan` succeeds for all 10 items in the for_each.",
            "xp": 375,
            "difficulty": "expert",
            "expected_time": "30m",
            "concepts": ["templatefile() function", "for_each evaluation", "expression evaluation efficiency"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "variables.tf": """\
variable "services" {
  type = map(object({
    port = number
    env  = string
  }))
  default = {
    svc_01 = { port = 8001, env = "prod" }
    svc_02 = { port = 8002, env = "prod" }
    svc_03 = { port = 8003, env = "staging" }
    svc_04 = { port = 8004, env = "prod" }
    svc_05 = { port = 8005, env = "dev" }
    svc_06 = { port = 8006, env = "prod" }
    svc_07 = { port = 8007, env = "staging" }
    svc_08 = { port = 8008, env = "prod" }
    svc_09 = { port = 8009, env = "dev" }
    svc_10 = { port = 8010, env = "prod" }
  }
}
""",
            "main.tf": """\
# BUG: The template path is wrong.
# The template file lives at templates/service.tpl
# but this code points to templates/configs/service.tpl (extra subdirectory that doesn't exist).
resource "local_file" "service_configs" {
  for_each = var.services
  filename = "${path.module}/output/${each.key}.conf"
  content  = templatefile("${path.module}/templates/configs/service.tpl", {
    service_name = each.key
    port         = each.value.port
    environment  = each.value.env
  })
}

output "config_count" {
  value = length(local_file.service_configs)
}
""",
            "templates/service.tpl": """\
# Service Configuration — Generated by Terraform
service_name = ${service_name}
port         = ${port}
environment  = ${environment}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "variables.tf": """\
variable "services" {
  type = map(object({
    port = number
    env  = string
  }))
  default = {
    svc_01 = { port = 8001, env = "prod" }
    svc_02 = { port = 8002, env = "prod" }
    svc_03 = { port = 8003, env = "staging" }
    svc_04 = { port = 8004, env = "prod" }
    svc_05 = { port = 8005, env = "dev" }
    svc_06 = { port = 8006, env = "prod" }
    svc_07 = { port = 8007, env = "staging" }
    svc_08 = { port = 8008, env = "prod" }
    svc_09 = { port = 8009, env = "dev" }
    svc_10 = { port = 8010, env = "prod" }
  }
}
""",
            "main.tf": """\
resource "local_file" "service_configs" {
  for_each = var.services
  filename = "${path.module}/output/${each.key}.conf"
  content  = templatefile("${path.module}/templates/service.tpl", {
    service_name = each.key
    port         = each.value.port
    environment  = each.value.env
  })
}

output "config_count" {
  value = length(local_file.service_configs)
}
""",
            "templates/service.tpl": """\
# Service Configuration — Generated by Terraform
service_name = ${service_name}
port         = ${port}
environment  = ${environment}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The error says Terraform cannot open the template file. Look at the full path passed to `templatefile()` and compare it to where the template actually lives in the project directory tree.",
            "The template file exists at `templates/service.tpl`. The broken config constructs the path as `templates/configs/service.tpl` — there is an extra `configs/` directory in the path that does not exist.",
            "Change the `templatefile()` path from `\"${path.module}/templates/configs/service.tpl\"` to `\"${path.module}/templates/service.tpl\"`. This removes the non-existent subdirectory.",
        ],
        "debrief": """\
# Lazy Evaluation and templatefile()

## What Was Broken
The `templatefile()` function was called with a path pointing to a non-existent file:
`templates/configs/service.tpl`. The actual template is at `templates/service.tpl`.

Since `templatefile()` is evaluated once per `for_each` entry at plan time, Terraform attempts
to read the file 10 times — all 10 fail immediately with a file-not-found error.

## The Fix
Correct the path: `templates/configs/service.tpl` → `templates/service.tpl`.

## Evaluation Efficiency with for_each
When using functions like `templatefile()` in a `for_each` loop:
- The function is called **N times** during planning (once per map entry)
- For identical templates with the same variables across all entries, precompute in `locals`
- For entry-specific templates (different vars per entry), the per-iteration call is unavoidable

```hcl
# Precompute in locals when template content is identical for all entries
locals {
  shared_config = templatefile("${path.module}/templates/shared.tpl", {
    env = var.environment
  })
}
```

## Key Takeaway
`templatefile()` reads the file at plan time. The path must be correct before the first plan.
Always use `${path.module}` to anchor paths to the module directory — this prevents breakage
when Terraform is run from a different working directory.
""",
        "common_mistakes": """\
# Common Mistakes

- **Wrong templatefile() path** — causes plan failure for ALL for_each iterations at once.
- **Using relative paths without ${path.module}** — breaks when Terraform is run from different directories.
- **Template variable name mismatches** — the vars map keys must match ${variable} names in the template exactly.
- **Not creating the output directory** — if the output directory doesn't exist, local_file will fail.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 12 — modular-monorepo
# ─────────────────────────────────────────────────────────────────────────────
def _level_12_modular_monorepo():
    return {
        "module": MODULE,
        "slug": "level-12-modular-monorepo",
        "mission": {
            "name": "Modular Monorepo",
            "description": (
                "A root module calls 3 child modules in sequence: generator → processor → reporter. "
                "The generator module has a wrong output reference — it uses `.id` instead of `.result` "
                "on a random_string resource. This causes a cascade failure through the entire chain. "
                "Fix the wrong output reference in the generator module."
            ),
            "objective": "Fix the wrong output reference in modules/generator/main.tf so `terraform plan` succeeds from the root.",
            "xp": 375,
            "difficulty": "expert",
            "expected_time": "30m",
            "concepts": ["modular monorepo structure", "module outputs", "cascade failure debugging"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
module "generator" {
  source = "./modules/generator"
}

module "processor" {
  source   = "./modules/processor"
  input_id = module.generator.token_id
}

module "reporter" {
  source    = "./modules/reporter"
  processed = module.processor.processed_value
}

output "final_report" {
  value = module.reporter.report
}
""",
            "modules/generator/terraform.tf": RANDOM_ONLY_TF,
            "modules/generator/main.tf": """\
resource "random_string" "token" {
  length  = 12
  special = false
  upper   = false
}

# BUG: random_string does not have an attribute called "id".
# The correct attribute is "result".
output "token_id" {
  value = random_string.token.id
}
""",
            "modules/processor/terraform.tf": RANDOM_ONLY_TF,
            "modules/processor/variables.tf": """\
variable "input_id" {
  type = string
}
""",
            "modules/processor/main.tf": """\
resource "random_string" "processed" {
  length  = 8
  special = false
  upper   = false
  keepers = {
    source = var.input_id
  }
}

output "processed_value" {
  value = random_string.processed.result
}
""",
            "modules/reporter/terraform.tf": RANDOM_ONLY_TF,
            "modules/reporter/variables.tf": """\
variable "processed" {
  type = string
}
""",
            "modules/reporter/main.tf": """\
output "report" {
  value = "processed:${var.processed}"
}
""",
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
module "generator" {
  source = "./modules/generator"
}

module "processor" {
  source   = "./modules/processor"
  input_id = module.generator.token_id
}

module "reporter" {
  source    = "./modules/reporter"
  processed = module.processor.processed_value
}

output "final_report" {
  value = module.reporter.report
}
""",
            "modules/generator/terraform.tf": RANDOM_ONLY_TF,
            "modules/generator/main.tf": """\
resource "random_string" "token" {
  length  = 12
  special = false
  upper   = false
}

output "token_id" {
  value = random_string.token.result
}
""",
            "modules/processor/terraform.tf": RANDOM_ONLY_TF,
            "modules/processor/variables.tf": """\
variable "input_id" {
  type = string
}
""",
            "modules/processor/main.tf": """\
resource "random_string" "processed" {
  length  = 8
  special = false
  upper   = false
  keepers = {
    source = var.input_id
  }
}

output "processed_value" {
  value = random_string.processed.result
}
""",
            "modules/reporter/terraform.tf": RANDOM_ONLY_TF,
            "modules/reporter/variables.tf": """\
variable "processed" {
  type = string
}
""",
            "modules/reporter/main.tf": """\
output "report" {
  value = "processed:${var.processed}"
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The error originates in `module.generator` — it references `random_string.token.id`. Which module is 'generator'? Look at modules/generator/main.tf.",
            "The `random_string` resource type exposes `result` (the generated string), not `id`. Check the Terraform Registry for `hashicorp/random` to confirm the available attributes.",
            "In `modules/generator/main.tf`, change the output value from `random_string.token.id` to `random_string.token.result`. This fixes the root cause; the cascade through processor and reporter will resolve automatically.",
        ],
        "debrief": """\
# Modular Monorepo

## What Was Broken
The `generator` module's output referenced `random_string.token.id` — an attribute that does
not exist on `random_string`. The correct attribute is `result`. Because `module.processor`
consumes `module.generator`'s output, and `module.reporter` consumes `module.processor`'s
output, the validation error cascaded through the entire dependency chain.

## The Fix
In `modules/generator/main.tf`: change `random_string.token.id` → `random_string.token.result`.

## Debugging Cascade Failures
When errors cascade through a module chain:
1. **Find the leaf module** — the one with no module dependencies (generator in this case)
2. **Read the error message carefully** — Terraform usually indicates the exact resource and attribute
3. **Fix the root cause** — fixing the leaf fixes all downstream errors automatically
4. **Validate modules independently** — `cd modules/generator && terraform validate`

## Monorepo Tradeoffs
| Aspect | Monorepo | Multi-repo |
|--------|---------|-----------|
| Atomic changes | Easy | Hard (multi-PR) |
| Module versioning | Implicit (git SHA) | Explicit (semver tags) |
| CI/CD scope | Single pipeline | Per-repo pipelines |
| Team boundaries | Harder to enforce | Easier via repo ACL |

## Key Takeaway
When debugging modular configs, start from the leaf modules and work outward. The error is
almost always in the earliest module in the dependency chain.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using .id instead of .result** — always verify attribute names in provider documentation.
- **Not testing modules independently** — validate each module in isolation before composition.
- **Missing output declarations** — a module that doesn't declare an output cannot pass values to callers.
- **Circular module dependencies** — Terraform cannot resolve cycles; design the dependency graph as a DAG.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 13 — cross-team-state
# ─────────────────────────────────────────────────────────────────────────────
def _level_13_cross_team_state():
    return {
        "module": MODULE,
        "slug": "level-13-cross-team-state",
        "mission": {
            "name": "Cross-Team State Sharing",
            "description": (
                "Team A manages infrastructure and exports outputs via a local state backend. "
                "Team B's config reads Team A's remote state but references two wrong output keys. "
                "Fix both wrong output key references in Team B's config."
            ),
            "objective": "Fix both wrong remote state output keys in team-b/main.tf so `terraform plan` succeeds after team-a is applied.",
            "xp": 375,
            "difficulty": "expert",
            "expected_time": "30m",
            "concepts": ["cross-team state sharing", "terraform_remote_state", "output name contracts"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "team-a/terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  backend "local" {
    path = "team-a.tfstate"
  }
}
""",
            "team-a/main.tf": """\
resource "random_string" "cluster_id" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "vpc_id" {
  length  = 12
  special = false
  upper   = false
}

output "cluster_identifier" {
  value       = random_string.cluster_id.result
  description = "Unique cluster identifier — consumed by team-b"
}

output "network_id" {
  value       = random_string.vpc_id.result
  description = "Network identifier — consumed by team-b"
}
""",
            "team-b/terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  backend "local" {
    path = "team-b.tfstate"
  }
}
""",
            "team-b/main.tf": """\
data "terraform_remote_state" "team_a" {
  backend = "local"
  config = {
    path = "../team-a/team-a.tfstate"
  }
}

# BUG 1: Team A exports "cluster_identifier" but Team B references "cluster_id" (wrong key).
# BUG 2: Team A exports "network_id" but Team B references "vpc_id" (wrong key).
resource "random_string" "app_instance" {
  length  = 6
  special = false
  upper   = false
  keepers = {
    cluster = data.terraform_remote_state.team_a.outputs.cluster_id
    network = data.terraform_remote_state.team_a.outputs.vpc_id
  }
}

output "app_instance_id" {
  value = random_string.app_instance.result
}
""",
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "team-a/terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  backend "local" {
    path = "team-a.tfstate"
  }
}
""",
            "team-a/main.tf": """\
resource "random_string" "cluster_id" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "vpc_id" {
  length  = 12
  special = false
  upper   = false
}

output "cluster_identifier" {
  value       = random_string.cluster_id.result
  description = "Unique cluster identifier — consumed by team-b"
}

output "network_id" {
  value       = random_string.vpc_id.result
  description = "Network identifier — consumed by team-b"
}
""",
            "team-b/terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  backend "local" {
    path = "team-b.tfstate"
  }
}
""",
            "team-b/main.tf": """\
data "terraform_remote_state" "team_a" {
  backend = "local"
  config = {
    path = "../team-a/team-a.tfstate"
  }
}

resource "random_string" "app_instance" {
  length  = 6
  special = false
  upper   = false
  keepers = {
    cluster = data.terraform_remote_state.team_a.outputs.cluster_identifier
    network = data.terraform_remote_state.team_a.outputs.network_id
  }
}

output "app_instance_id" {
  value = random_string.app_instance.result
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# Apply Team A first to create their state file
cd team-a
terraform init -no-color -input=false 2>&1
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: team-a apply failed"
    exit 1
fi
cd ..

# Plan Team B — should succeed with correct output key references
cd team-b
terraform init -no-color -input=false 2>&1
terraform plan -detailed-exitcode -no-color -input=false 2>&1
PLAN_CODE=$?
cd ..

if [[ $PLAN_CODE -eq 0 ]] || [[ $PLAN_CODE -eq 2 ]]; then
    echo "PASS: cross-team state references are correct — team-b plan succeeded"
    exit 0
fi
echo "FAIL: team-b plan failed — check remote state output key references"
exit 1
"""),
        "hints": [
            "Apply team-a first (`cd team-a && terraform init && terraform apply`), then plan team-b. The error will show which output keys don't exist in team-a's state. Compare with team-a/main.tf output block names.",
            "Team A's outputs are named `cluster_identifier` and `network_id`. Team B references `cluster_id` and `vpc_id` — both names are wrong. The names must match exactly.",
            "In team-b/main.tf, update the keepers map: change `cluster_id` → `cluster_identifier` and `vpc_id` → `network_id` in the remote state output references.",
        ],
        "debrief": """\
# Cross-Team State Sharing

## What Was Broken
Team B referenced two output keys from Team A's remote state with incorrect names:
- `cluster_id` → should be `cluster_identifier`
- `vpc_id` → should be `network_id`

This is the most common failure in cross-team state sharing — the consuming team uses their
internal shorthand instead of the exact output name defined by the producing team.

## The Fix
Update Team B to use the exact output key names as defined in Team A.

## Establishing Output Contracts
Treat remote state outputs as a versioned API:
1. **Document all outputs** — use `description` on every shared output
2. **Create an interface doc** — a README in the state-producing config listing all outputs
3. **Never rename outputs without coordinating** — renaming breaks all consumers silently
4. **Consider a wrapper module** — a thin module that wraps the remote_state read, centralizing the contract in one place

## When Remote State Fails
If team-b can't access team-a's state:
- State file doesn't exist yet → team-a must apply first
- Wrong path → check backend config and relative path
- Key doesn't exist → verify against team-a's actual outputs (`terraform output` in team-a dir)

## Key Takeaway
Cross-team state sharing creates implicit coupling. Treat output key names as part of a
public API contract and manage them with the same care as external API changes.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using internal shorthand instead of actual output names** — always check the source config.
- **Renaming outputs without updating all consumers** — silent breakage in downstream teams.
- **Not documenting shared outputs** — consumers must guess names and frequently get them wrong.
- **Reading remote state before it exists** — always apply the producing config before the consuming config.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 14 — workspace-scaling
# ─────────────────────────────────────────────────────────────────────────────
def _level_14_workspace_scaling():
    return {
        "module": MODULE,
        "slug": "level-14-workspace-scaling",
        "mission": {
            "name": "Workspace Scaling",
            "description": (
                "A config uses `terraform.workspace` for resource naming but the convention is wrong. "
                "It concatenates components in the wrong order and uses an underscore separator "
                "instead of a dash. The required convention is `{workspace}-token-{N}` (dash-separated, "
                "workspace first). Fix the workspace-based naming throughout the config."
            ),
            "objective": "Fix the workspace-based resource naming to follow `{workspace}-token-{N}` convention, then verify apply outputs the correct names.",
            "xp": 350,
            "difficulty": "expert",
            "expected_time": "28m",
            "concepts": ["terraform.workspace", "workspace naming at scale", "multi-environment patterns"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
# BUG: The naming convention is wrong.
# Required: "${terraform.workspace}-token-${count.index + 1}"  (workspace first, dash separator)
# Broken:   "token_${count.index + 1}_${terraform.workspace}"  (wrong order, underscore separator)
resource "random_string" "workspace_tokens" {
  count   = 5
  length  = 10
  special = false
  upper   = false
  keepers = {
    name = "token_${count.index + 1}_${terraform.workspace}"
  }
}

output "workspace_name" {
  value = terraform.workspace
}

output "token_names" {
  value = [for i, t in random_string.workspace_tokens : "token_${i + 1}_${terraform.workspace}"]
}

output "token_values" {
  value = random_string.workspace_tokens[*].result
}
""",
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
resource "random_string" "workspace_tokens" {
  count   = 5
  length  = 10
  special = false
  upper   = false
  keepers = {
    name = "${terraform.workspace}-token-${count.index + 1}"
  }
}

output "workspace_name" {
  value = terraform.workspace
}

output "token_names" {
  value = [for i, t in random_string.workspace_tokens : "${terraform.workspace}-token-${i + 1}"]
}

output "token_values" {
  value = random_string.workspace_tokens[*].result
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# Plan must succeed
terraform plan -detailed-exitcode -no-color -input=false 2>&1
PLAN_CODE=$?
if [[ $PLAN_CODE -ne 0 ]] && [[ $PLAN_CODE -ne 2 ]]; then
    echo "FAIL: plan failed in default workspace"
    exit 1
fi

# Apply to check outputs
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: apply failed"
    exit 1
fi

NAMES=$(terraform output -json token_names 2>/dev/null || echo "[]")

# In default workspace, expect "default-token-1" pattern
if echo "$NAMES" | grep -q "default-token-1"; then
    echo "PASS: workspace naming convention is correct (workspace-token-N with dash separator)"
    exit 0
fi

echo "FAIL: token names do not follow expected convention 'workspace-token-N'"
echo "Got: $NAMES"
exit 1
"""),
        "hints": [
            "Run `terraform apply` and check the `token_names` output. The current convention produces names like `token_1_default` — but the required convention is `default-token-1` (workspace first, dash separator).",
            "The keepers map and the `token_names` for expression both need to be updated. Look for the string interpolation in both places and compare the order and separator character.",
            "In both the `keepers` block and the `token_names` for expression, change the interpolation to use `\"${terraform.workspace}-token-${count.index + 1}\"` (and `i + 1` in the for expression). Workspace comes first, separated by a dash.",
        ],
        "debrief": """\
# Workspace Scaling

## What Was Broken
The workspace-based naming convention was incorrect in two ways:
1. **Wrong order**: `token_{N}_{workspace}` instead of `{workspace}-token-{N}`
2. **Wrong separator**: underscores (`_`) instead of dashes (`-`)

This inconsistency means resources in different workspaces would be named in a non-standard
way, making it hard to quickly identify the environment a resource belongs to.

## The Fix
Use `${terraform.workspace}-token-${count.index + 1}` consistently in both the keepers map
and the token_names output expression.

## Workspace Naming Best Practices
Convention: `{environment}-{resource-type}-{identifier}`

| Example | Environment | Resource | ID |
|---------|------------|---------|-----|
| `prod-token-1` | prod | token | 1 |
| `staging-token-1` | staging | token | 1 |
| `dev-token-1` | dev | token | 1 |

**Why environment first?**
- Resources sort by environment alphabetically
- Grepping logs for `prod-` finds all prod resources immediately
- Naming is self-describing when viewed in any tool

## Workspace Anti-Patterns
- Using workspaces for prod/non-prod isolation in large orgs → use separate accounts/subscriptions
- Not documenting the workspace convention → new team members use wrong names
- `terraform.workspace == "default"` in production → rename to match the environment

## Key Takeaway
Establish naming conventions early and enforce them consistently. Inconsistent naming across
workspaces compounds into a maintenance burden at hundreds or thousands of resources.
""",
        "common_mistakes": """\
# Common Mistakes

- **Inconsistent separators** — mixing underscores and dashes in different parts of the same name.
- **Wrong component order** — environment last makes filtering by environment much harder.
- **Forgetting terraform.workspace in some resource names** — some resources named, others not.
- **Using workspaces for true prod isolation** — workspaces share the same state backend and blast radius.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 15 — ci-cd-performance
# ─────────────────────────────────────────────────────────────────────────────
def _level_15_ci_cd_performance():
    return {
        "module": MODULE,
        "slug": "level-15-ci-cd-performance",
        "mission": {
            "name": "CI/CD Pipeline Performance",
            "description": (
                "A CI/CD config has two problems: the provider source namespace is wrong (causing "
                "terraform init to fail), and the .terraform.lock.hcl file is missing from source "
                "control (causing every CI run to re-resolve provider versions from the registry). "
                "Fix the provider source AND add a valid lock file to the solution directory."
            ),
            "objective": "Fix the provider source error and ensure a .terraform.lock.hcl exists so CI/CD can run faster inits.",
            "xp": 400,
            "difficulty": "expert",
            "expected_time": "35m",
            "concepts": ["CI/CD optimization", ".terraform.lock.hcl", "terraform init performance", "provider source"],
        },
        "broken": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      # BUG: Wrong provider source namespace. The correct source is "hashicorp/random".
      source  = "hashicorp-legacy/random"
      version = "~> 3.6"
    }
  }
}
""",
            "main.tf": """\
resource "random_string" "ci_token" {
  length  = 16
  special = false
}

output "ci_token" {
  value = random_string.ci_token.result
}
""",
        },
        "solution": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
""",
            "main.tf": """\
resource "random_string" "ci_token" {
  length  = 16
  special = false
}

output "ci_token" {
  value = random_string.ci_token.result
}
""",
            ".terraform.lock.hcl": """\
# This file is maintained automatically by "terraform init".
# Manual edits may be lost in future updates.

provider "registry.terraform.io/hashicorp/random" {
  version     = "3.6.3"
  constraints = "~> 3.6"
  hashes = [
    "h1:Fnaec9vA8sZ8BXVlN3Xn9Xs5Ev1k65Hz7SCl6oM6Gkg=",
    "zh:1bfd2e54b4eee8c761a40b6d99d45880b3a71abc18a9a7a5319204da9c8363b2",
    "zh:21a15ac74adb8ba499aab989a4248321b51946e5431219b56ef827e2a7a49724",
    "zh:221a4ee4c462de86f6e11cb636a64f1f4d4c82e3dd4d6e76c0a58ae3b05afa5",
    "zh:2aaaa1884b6b394e9a609308a3c0a2f044c64ccea1e6ef1ece822c5ee2e7cac7",
    "zh:57a5ec8c220ab4a93af21d32ce2ec8c82b9e2fae10fc7e9ebfac7abc3baaa4e9",
    "zh:6f8c78796ba1db0d8f76f8fde5f0e7ad5ad04a5e17c7f0ca5d6c5a9b4a0d9e1",
    "zh:78d5eefdd9e8f8de4fa5dc0c6e3eba25b3edab08b5b79e8b2e4b6c8d9a2c4e6",
    "zh:8c1d3e5f6a7b9c2d4e8f0a1b3c5d7e9f0a2b4c6d8e0f2a4b6c8d0e2f4a6b8",
    "zh:9e2f4a6b8c0d2e4f6a8b0c2d4e6f8a0b2c4d6e8f0a2b4c6d8e0f2a4b6c8d0",
    "zh:a0b2c4d6e8f0a2b4c6d8e0f2a4b6c8d0e2f4a6b8c0d2e4f6a8b0c2d4e6f8",
    "zh:b2c4d6e8f0a2b4c6d8e0f2a4b6c8d0e2f4a6b8c0d2e4f6a8b0c2d4e6f8a0",
  ]
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# terraform init must succeed with the corrected provider source
if ! terraform init -no-color -input=false 2>&1; then
    echo "FAIL: terraform init failed — provider source may be wrong"
    exit 1
fi

# Check that a lock file exists
if [[ ! -f ".terraform.lock.hcl" ]]; then
    echo "FAIL: .terraform.lock.hcl not found — commit this file for CI/CD performance"
    exit 1
fi

# Plan to confirm the config is valid end-to-end
terraform plan -detailed-exitcode -no-color -input=false 2>&1
PLAN_CODE=$?
if [[ $PLAN_CODE -eq 0 ]] || [[ $PLAN_CODE -eq 2 ]]; then
    echo "PASS: init succeeded, lock file exists, and plan succeeded"
    exit 0
fi
echo "FAIL: terraform plan failed after successful init"
exit 1
"""),
        "hints": [
            "Run `terraform init`. The error says the provider `hashicorp-legacy/random` does not exist on the Terraform Registry. The correct source namespace for all official HashiCorp providers is `hashicorp/`, not `hashicorp-legacy/`.",
            "After fixing the source to `hashicorp/random`, run `terraform init` — it will succeed and generate a `.terraform.lock.hcl` file automatically. This file records the exact provider version selected.",
            "Commit the `.terraform.lock.hcl` file to your repository. In CI, use `terraform init -lockfile=readonly` (or `-upgrade=false`) to skip version resolution and use the committed lock file, dramatically speeding up CI runs.",
        ],
        "debrief": """\
# CI/CD Pipeline Performance

## What Was Broken
1. **Wrong provider source**: `hashicorp-legacy/random` does not exist. The correct source is
   `hashicorp/random`. Provider sources follow the format `{namespace}/{type}`.
2. **Missing lock file**: Without `.terraform.lock.hcl` committed, every CI run performs full
   version resolution from the registry — slow and potentially non-deterministic.

## The Fix
1. Correct the provider source to `hashicorp/random`
2. Run `terraform init` to generate the lock file
3. Commit `.terraform.lock.hcl` to version control

## CI/CD Performance Playbook

### 1. Lock File Strategy
```bash
# Commit the lock file to your repo after initial init or version upgrades
git add .terraform.lock.hcl
git commit -m "chore: update terraform provider lock file"

# In CI: use readonly to validate against committed lock, skip resolution
terraform init -lockfile=readonly
```

### 2. Provider Cache
```bash
export TF_PLUGIN_CACHE_DIR=/opt/ci/terraform-cache
terraform init  # populates cache on first run; symlinks on subsequent runs
```

### 3. Plan File Approval Gate
```bash
# CI Stage 1 (on PR): generate plan
terraform plan -out=tfplan
# Store tfplan as CI artifact

# CI Stage 2 (on merge/approval): apply saved plan
terraform apply tfplan
```

### 4. Parallelism Tuning
```bash
terraform apply -parallelism=20  # for large configs with high-throughput providers
```

## Key Takeaway
The three pillars of fast, reliable CI/CD with Terraform: committed lock files for
reproducibility, provider caching for speed, and saved plan files for safety and auditability.
""",
        "common_mistakes": """\
# Common Mistakes

- **Not committing .terraform.lock.hcl** — causes version drift and slow CI runs on every pipeline execution.
- **Wrong provider source namespace** — `hashicorp-legacy`, `HashiCorp`, `HASHICORP` are all wrong.
- **Running terraform init without caching** — unnecessarily downloads providers on every CI run.
- **Not using plan files in CI** — allows a new commit between plan and apply to sneak in unexpected changes.
- **Forgetting -input=false in CI** — pipelines hang indefinitely waiting for stdin that never arrives.
""",
    }


if __name__ == "__main__":
    build()
