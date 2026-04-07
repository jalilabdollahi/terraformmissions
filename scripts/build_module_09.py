#!/usr/bin/env python3
"""Module 9 — Workspaces (12 levels, Intermediate)."""
from __future__ import annotations

from scripts.build_utils import (
    LOCAL_ONLY_TF,
    print_done,
    validate_custom,
    validate_tf_plan,
    validate_tf_validate,
    write_level,
)

MODULE = "module-9-workspaces"


def build() -> int:
    levels = [
        _level_01_workspace_create(),
        _level_02_workspace_interpolation(),
        _level_03_workspace_conditional(),
        _level_04_workspace_variable(),
        _level_05_workspace_count(),
        _level_06_workspace_backend(),
        _level_07_workspace_isolation(),
        _level_08_workspace_for_each(),
        _level_09_workspace_module_input(),
        _level_10_workspace_list_select(),
        _level_11_workspace_destroy_order(),
        _level_12_workspace_vs_state_files(),
    ]
    for lvl in levels:
        write_level(lvl)
    print_done(MODULE, len(levels))
    return len(levels)


# ─────────────────────────────────────────────────────────────────────────────
# Level 1 — workspace-create
# ─────────────────────────────────────────────────────────────────────────────
def _level_01_workspace_create():
    return {
        "module": MODULE,
        "slug": "level-1-workspace-create",
        "mission": {
            "name": "Workspace Typo",
            "description": "The config uses `terraform.workspace` to build a filename, but there is a typo: `terraform.workpsace` instead of `terraform.workspace`.",
            "objective": "Fix the typo so `terraform validate` passes.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["terraform.workspace", "typo", "interpolation"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Typo: "workpsace" should be "workspace"
# Fix: change terraform.workpsace to terraform.workspace

resource "local_file" "env_marker" {
  content  = "environment: ${terraform.workspace}"
  filename = "${path.module}/${terraform.workpsace}.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "env_marker" {
  content  = "environment: ${terraform.workspace}"
  filename = "${path.module}/${terraform.workspace}.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. Terraform will report that `terraform.workpsace` is not a valid reference. Look carefully at the spelling.",
            "`terraform.workspace` is a built-in value that returns the name of the current workspace. It has a specific spelling: w-o-r-k-s-p-a-c-e.",
            "Change `terraform.workpsace` to `terraform.workspace` in the `filename` attribute.",
        ],
        "debrief": """\
# Workspace Typo

## What Was Broken
`terraform.workpsace` is a misspelling of `terraform.workspace`. Terraform does not recognise
the misspelt attribute and raises a validation error.

## The Fix
```hcl
filename = "${path.module}/${terraform.workspace}.txt"
```

## terraform.workspace
`terraform.workspace` is a built-in expression that returns the name of the currently selected
workspace as a string. In the default workspace it returns `"default"`.

```bash
terraform workspace show   # prints current workspace name
```

## Use Cases
- Naming resources per environment: `"${var.name}-${terraform.workspace}"`
- Conditional logic: `terraform.workspace == "production" ? 2 : 1`
- Selecting environment-specific config from a map
""",
        "common_mistakes": """\
# Common Mistakes

- **Typos in `terraform.workspace`** — it is easy to transpose letters; validate catches this immediately.
- **Using `workspace` alone** — `workspace` is not a standalone variable; always use the full `terraform.workspace`.
- **Hardcoding workspace names** — environments change; prefer maps or conditionals over hardcoded strings.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 2 — workspace-interpolation
# ─────────────────────────────────────────────────────────────────────────────
def _level_02_workspace_interpolation():
    return {
        "module": MODULE,
        "slug": "level-2-workspace-interpolation",
        "mission": {
            "name": "Unquoted String in Condition",
            "description": "A workspace conditional is missing quotes around the string `\"default\"`, causing a parse error.",
            "objective": "Fix the condition so `terraform validate` passes.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["workspace interpolation", "conditional expression", "string literals"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# The comparison uses an unquoted identifier "default" instead of the string "default".
# Fix: add quotes around default in the condition.

locals {
  env = terraform.workspace == default ? "dev" : terraform.workspace
}

output "environment" {
  value = local.env
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
locals {
  env = terraform.workspace == "default" ? "dev" : terraform.workspace
}

output "environment" {
  value = local.env
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. Terraform interprets `default` without quotes as a variable or reference, not a string literal.",
            "In HCL, string values must be surrounded by double quotes. `default` without quotes is treated as an identifier, not the word \"default\".",
            "Change `terraform.workspace == default` to `terraform.workspace == \"default\"`.",
        ],
        "debrief": """\
# Unquoted String in Condition

## What Was Broken
`default` without quotes is treated as an identifier (a reference to a variable or object named
`default`), not the string `"default"`. HCL string literals require double quotes.

## The Fix
```hcl
locals {
  env = terraform.workspace == "default" ? "dev" : terraform.workspace
}
```

## String Literals in HCL
```hcl
# Correct — double-quoted string
condition = terraform.workspace == "default"

# Wrong — unquoted identifier
condition = terraform.workspace == default
```

## Conditional Expression Syntax
```
condition ? true_value : false_value
```
Both `true_value` and `false_value` must be valid expressions of the same type.
""",
        "common_mistakes": """\
# Common Mistakes

- **Unquoted strings** — always use double quotes for string literals in HCL.
- **Single quotes** — HCL does not support single-quoted strings.
- **Forgetting the colon** — the conditional expression requires `?` and `:` separators.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 3 — workspace-conditional
# ─────────────────────────────────────────────────────────────────────────────
def _level_03_workspace_conditional():
    return {
        "module": MODULE,
        "slug": "level-3-workspace-conditional",
        "mission": {
            "name": "Production Misspelled",
            "description": "A workspace conditional checks for `\"prodution\"` (missing the 'c'), so it never matches the actual workspace name `\"production\"`.",
            "objective": "Fix the typo so the count conditional works correctly and `terraform plan` passes.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["workspace-based conditionals", "count", "string comparison"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Typo: "prodution" should be "production" (missing the letter 'c').
# Fix: correct the workspace name in the condition.

resource "local_file" "config" {
  count    = terraform.workspace == "prodution" ? 2 : 1
  content  = "instance ${count.index}"
  filename = "${path.module}/config-${count.index}.txt"
}

output "instance_count" {
  value = length(local_file.config)
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  count    = terraform.workspace == "production" ? 2 : 1
  content  = "instance ${count.index}"
  filename = "${path.module}/config-${count.index}.txt"
}

output "instance_count" {
  value = length(local_file.config)
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The plan may succeed, but the logic is wrong — the typo means the condition never evaluates to `true` for the `production` workspace.",
            "The string `\"prodution\"` is missing the letter `c`. The intended workspace name is `\"production\"`.",
            "Change `\"prodution\"` to `\"production\"` in the count conditional.",
        ],
        "debrief": """\
# Production Misspelled

## What Was Broken
The workspace name `"prodution"` is a typo — it is missing the letter `c`. Because string
comparisons in Terraform are exact, the condition `terraform.workspace == "prodution"` will
never be `true` when the actual workspace is named `"production"`.

## The Fix
```hcl
count = terraform.workspace == "production" ? 2 : 1
```

## Why This Is Dangerous
This bug does not cause an error — the plan succeeds, but with the wrong resource count.
Logic bugs from string typos are silent and can lead to under- or over-provisioning.

## Defensive Pattern
Use a variable with validation to enforce workspace names:
```hcl
variable "workspace" {
  default = terraform.workspace
  validation {
    condition     = contains(["default", "staging", "production"], var.workspace)
    error_message = "Workspace must be one of: default, staging, production."
  }
}
```
""",
        "common_mistakes": """\
# Common Mistakes

- **Silent typos in conditionals** — the plan succeeds with wrong logic; always test workspace-based branching.
- **Case sensitivity** — `"Production"` != `"production"`.
- **Hardcoding workspace names** — consider extracting workspace names into a `locals` or `variable` block for reuse.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 4 — workspace-variable
# ─────────────────────────────────────────────────────────────────────────────
def _level_04_workspace_variable():
    return {
        "module": MODULE,
        "slug": "level-4-workspace-variable",
        "mission": {
            "name": "Map Lookup Gone Wrong",
            "description": "A `locals` block builds a config map and tries to look up the current workspace's value. The lookup syntax is wrong.",
            "objective": "Fix the map access syntax so `terraform validate` passes.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["workspace variable lookup", "map access", "locals"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# The map lookup syntax is wrong — locals.env_config[terraform.workspace]
# is not valid; you access locals via local.env_config, not locals.env_config.
# Fix: change locals.env_config to local.env_config

locals {
  env_config = {
    default = "dev-config"
    staging = "stg-config"
  }

  current_config = locals.env_config[terraform.workspace]
}

output "config_value" {
  value = local.current_config
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
locals {
  env_config = {
    default = "dev-config"
    staging = "stg-config"
  }

  current_config = local.env_config[terraform.workspace]
}

output "config_value" {
  value = local.current_config
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. Terraform reports that `locals` is not a valid reference. In HCL, `locals` is the block keyword but `local` is the reference prefix.",
            "To access a value defined in a `locals` block, use the prefix `local.` (singular), not `locals.` (plural with an s).",
            "Change `locals.env_config[terraform.workspace]` to `local.env_config[terraform.workspace]`.",
        ],
        "debrief": """\
# Map Lookup Gone Wrong

## What Was Broken
`locals` is the **block keyword** used to declare local values. To **reference** a local value,
the correct prefix is `local.` (singular), not `locals.`.

## The Fix
```hcl
current_config = local.env_config[terraform.workspace]
```

## locals Block vs local. Reference
```hcl
# Declaration — uses "locals" (plural) block keyword
locals {
  my_value = "hello"
}

# Reference — uses "local." (singular) prefix
output "example" {
  value = local.my_value
}
```

## Map Lookup with workspace
```hcl
locals {
  env_map = {
    default    = "dev"
    staging    = "staging"
    production = "prod"
  }
  env = local.env_map[terraform.workspace]
}
```
Use `try(local.env_map[terraform.workspace], "dev")` if not all workspaces are guaranteed to be in the map.
""",
        "common_mistakes": """\
# Common Mistakes

- **`locals.` instead of `local.`** — the reference prefix is always `local.` (singular).
- **Missing workspace key in map** — if the current workspace is not in the map, Terraform raises a key-not-found error at plan time.
- **Not using `try()` for optional keys** — wrap with `try(local.map[terraform.workspace], "default")` for safety.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 5 — workspace-count
# ─────────────────────────────────────────────────────────────────────────────
def _level_05_workspace_count():
    return {
        "module": MODULE,
        "slug": "level-5-workspace-count",
        "mission": {
            "name": "Missing terraform. Prefix",
            "description": "A `count` expression references `workspace` without the required `terraform.` prefix.",
            "objective": "Add the `terraform.` prefix so `terraform validate` passes.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["terraform.workspace", "workspace-based count", "variable references"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# "workspace" alone is not a valid reference — it needs the terraform. prefix.
# Fix: change workspace == "default" to terraform.workspace == "default"

resource "local_file" "optional" {
  count    = workspace == "default" ? 1 : 0
  content  = "only in default workspace"
  filename = "${path.module}/default-only.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "optional" {
  count    = terraform.workspace == "default" ? 1 : 0
  content  = "only in default workspace"
  filename = "${path.module}/default-only.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. Terraform reports that `workspace` is not a known reference. The workspace value lives under the `terraform` object.",
            "`terraform` is a special object in Terraform that exposes metadata about the current run. Its attributes include `terraform.workspace` and `terraform.env` (deprecated alias).",
            "Change `workspace == \"default\"` to `terraform.workspace == \"default\"`.",
        ],
        "debrief": """\
# Missing terraform. Prefix

## What Was Broken
`workspace` without a prefix is not a valid Terraform expression. The workspace name is
exposed as `terraform.workspace` — an attribute of the built-in `terraform` object.

## The Fix
```hcl
count = terraform.workspace == "default" ? 1 : 0
```

## The terraform Object
The `terraform` object exposes:
| Attribute              | Description |
|-----------------------|-------------|
| `terraform.workspace` | Current workspace name (string) |
| `terraform.env`       | Deprecated alias for `terraform.workspace` |

## Why `workspace` Alone Fails
Terraform would interpret `workspace` as a reference to a variable named `workspace`.
If no such variable is declared, validation fails.
""",
        "common_mistakes": """\
# Common Mistakes

- **Omitting `terraform.` prefix** — always write `terraform.workspace`, never just `workspace`.
- **Using `terraform.env`** — this is a deprecated alias; prefer `terraform.workspace`.
- **Declaring a variable named `workspace`** — while valid, it shadows the intent and creates confusion.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 6 — workspace-backend
# ─────────────────────────────────────────────────────────────────────────────
def _level_06_workspace_backend():
    return {
        "module": MODULE,
        "slug": "level-6-workspace-backend",
        "mission": {
            "name": "No Interpolation in Backend",
            "description": "The backend `path` attribute tries to use `${terraform.workspace}` interpolation, which is not allowed in backend blocks.",
            "objective": "Remove the invalid interpolation and use a static path. Workspaces automatically separate state. `terraform init` must succeed.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["workspace backend isolation", "backend limitations", "static backend config"],
        },
        "broken": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  # Invalid: cannot use terraform.workspace interpolation inside backend block
  backend "local" {
    path = "terraform-${terraform.workspace}.tfstate"
  }
}
""",
            "main.tf": """\
resource "local_file" "marker" {
  content  = "workspace: ${terraform.workspace}"
  filename = "${path.module}/marker.txt"
}
""",
        },
        "solution": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  # Static path — workspaces automatically store state in separate subdirectories
  backend "local" {
    path = "terraform.tfstate"
  }
}
""",
            "main.tf": """\
resource "local_file" "marker" {
  content  = "workspace: ${terraform.workspace}"
  filename = "${path.module}/marker.txt"
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if terraform init -no-color -input=false -reconfigure 2>&1; then
    echo "✅ PASS: terraform init succeeded"
    exit 0
fi
echo "❌ FAIL: terraform init failed — backend block likely still has interpolation"
exit 1
"""),
        "hints": [
            "Run `terraform init`. It fails with an error about interpolation in the backend block. Backend configuration is evaluated before the Terraform runtime, so no expressions are allowed.",
            "With workspace support, Terraform automatically stores state in separate files per workspace. For a local backend, the default workspace uses `terraform.tfstate` and other workspaces use `terraform.tfstate.d/<name>/terraform.tfstate`.",
            "Remove the `${terraform.workspace}` interpolation and use a static path: `path = \"terraform.tfstate\"`.",
        ],
        "debrief": """\
# No Interpolation in Backend

## What Was Broken
Backend configuration blocks do not support interpolation or expressions. They are processed
before the Terraform language runtime initialises, so `${terraform.workspace}` has no meaning there.

## The Fix
```hcl
backend "local" {
  path = "terraform.tfstate"
}
```

## How Workspaces Isolate State Automatically
When using workspaces, Terraform automatically separates state:
- **default workspace**: `terraform.tfstate`
- **other workspaces**: `terraform.tfstate.d/<workspace-name>/terraform.tfstate`

You do **not** need to include the workspace name in the path — it is handled automatically.

## Key Rule
Backend blocks must contain only literal values (strings, numbers, booleans). No variables,
no locals, no `terraform.workspace`.

## Dynamic Backend Alternative
Use `-backend-config` flags or environment variables for dynamic backend configuration:
```bash
terraform init -backend-config="path=envs/staging/terraform.tfstate"
```
""",
        "common_mistakes": """\
# Common Mistakes

- **Interpolation in backend** — backend blocks are static; use `-backend-config` for dynamic values.
- **Manually naming per-workspace paths** — Terraform handles workspace state isolation automatically.
- **Confusing local backend path with workspace state path** — the `path` is the base; workspaces create subdirectories automatically.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 7 — workspace-isolation
# ─────────────────────────────────────────────────────────────────────────────
def _level_07_workspace_isolation():
    return {
        "module": MODULE,
        "slug": "level-7-workspace-isolation",
        "mission": {
            "name": "Name Collision Across Workspaces",
            "description": "Two resources share the same output filename regardless of workspace. Adding the workspace name to the filename prevents collisions when both workspaces run in the same directory.",
            "objective": "Add `terraform.workspace` as a suffix to the resource filename so `terraform plan` passes and names are unique per workspace.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["workspace isolation", "resource naming", "terraform.workspace"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Both workspaces would write to the same "app.conf" file.
# Fix: add the workspace name to the filename to keep workspaces isolated.
# Change filename to "${path.module}/app-${terraform.workspace}.conf"

resource "local_file" "app_config" {
  content  = "env=${terraform.workspace}"
  filename = "${path.module}/app.conf"
}

output "config_path" {
  value = local_file.app_config.filename
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "app_config" {
  content  = "env=${terraform.workspace}"
  filename = "${path.module}/app-${terraform.workspace}.conf"
}

output "config_path" {
  value = local_file.app_config.filename
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The plan itself may succeed, but the design flaw is that multiple workspaces would overwrite the same file. The fix is to include the workspace name in the filename.",
            "Use `terraform.workspace` in the filename to make each workspace's file unique: `\"app-${terraform.workspace}.conf\"`.",
            "Change `filename = \"${path.module}/app.conf\"` to `filename = \"${path.module}/app-${terraform.workspace}.conf\"`.",
        ],
        "debrief": """\
# Name Collision Across Workspaces

## What Was Broken
When multiple workspaces share the same working directory, resources with identical names
(like a fixed filename `app.conf`) will overwrite each other. Each workspace should produce
uniquely named resources.

## The Fix
```hcl
resource "local_file" "app_config" {
  content  = "env=${terraform.workspace}"
  filename = "${path.module}/app-${terraform.workspace}.conf"
}
```

## Workspace Isolation Pattern
Include `terraform.workspace` in any resource name, filename, or identifier that needs to be
unique per environment:

```hcl
# Resource tags
tags = {
  Environment = terraform.workspace
  Name        = "${var.name}-${terraform.workspace}"
}

# Filenames
filename = "${path.module}/${terraform.workspace}-config.txt"
```

## Why It Matters
Without workspace-unique names, deploying to `staging` can overwrite `default` resources,
causing silent data loss or configuration corruption.
""",
        "common_mistakes": """\
# Common Mistakes

- **Fixed filenames across workspaces** — always suffix resource identifiers with the workspace name.
- **Assuming workspaces are fully isolated** — only the state is isolated; physical resources (files, cloud objects) are NOT automatically separated.
- **Forgetting the workspace in remote resource names** — cloud resource names (S3 buckets, DNS records) must also be unique per workspace.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 8 — workspace-for-each
# ─────────────────────────────────────────────────────────────────────────────
def _level_08_workspace_for_each():
    return {
        "module": MODULE,
        "slug": "level-8-workspace-for-each",
        "mission": {
            "name": "Missing Workspace Key in Map",
            "description": "A `for_each` uses a map keyed by workspace names, but the `default` workspace is missing from the map.",
            "objective": "Add the `default` key to the map so `terraform plan` succeeds in the default workspace.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["for_each workspace config", "map keys", "workspace conditional"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# The workspace_config map is missing the "default" key.
# Running terraform plan in the default workspace will fail because the key is absent.
# Fix: add a "default" entry to the workspace_config map.

locals {
  workspace_config = {
    staging    = { env = "staging",    replicas = 1 }
    production = { env = "production", replicas = 3 }
  }
}

resource "local_file" "env_config" {
  for_each = local.workspace_config[terraform.workspace] != null ? { this = local.workspace_config[terraform.workspace] } : {}
  content  = "env=${each.value.env} replicas=${each.value.replicas}"
  filename = "${path.module}/${terraform.workspace}.conf"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
locals {
  workspace_config = {
    default    = { env = "development", replicas = 1 }
    staging    = { env = "staging",     replicas = 1 }
    production = { env = "production",  replicas = 3 }
  }
}

resource "local_file" "env_config" {
  for_each = local.workspace_config[terraform.workspace] != null ? { this = local.workspace_config[terraform.workspace] } : {}
  content  = "env=${each.value.env} replicas=${each.value.replicas}"
  filename = "${path.module}/${terraform.workspace}.conf"
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan` in the default workspace. Terraform reports a key-not-found error because `local.workspace_config[\"default\"]` does not exist.",
            "Add a `default` entry to the `workspace_config` map. For example: `default = { env = \"development\", replicas = 1 }`.",
            "Add `default = { env = \"development\", replicas = 1 }` as the first key in the `workspace_config` map.",
        ],
        "debrief": """\
# Missing Workspace Key in Map

## What Was Broken
The `workspace_config` map had entries for `staging` and `production`, but not `default`.
When running in the default workspace, `local.workspace_config["default"]` throws an error.

## The Fix
```hcl
locals {
  workspace_config = {
    default    = { env = "development", replicas = 1 }
    staging    = { env = "staging",     replicas = 1 }
    production = { env = "production",  replicas = 3 }
  }
}
```

## Safe Lookup Pattern
If not all workspaces need to be in the map, use `try()` to provide a fallback:
```hcl
locals {
  config = try(
    local.workspace_config[terraform.workspace],
    local.workspace_config["default"]
  )
}
```

## Best Practice
Always include a `default` entry in workspace-keyed maps. It acts as the fallback for any
workspace not explicitly listed and prevents accidental plan failures.
""",
        "common_mistakes": """\
# Common Mistakes

- **Omitting the `default` workspace** — new engineers often forget `default` is a real workspace.
- **Using `lookup()` without a default** — `lookup(map, key)` without a third argument panics on missing keys; add `lookup(map, key, fallback_value)`.
- **Assuming all workspaces are pre-known** — new workspaces can be created at any time; always handle unknown workspace names gracefully.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 9 — workspace-module-input
# ─────────────────────────────────────────────────────────────────────────────
def _level_09_workspace_module_input():
    return {
        "module": MODULE,
        "slug": "level-9-workspace-module-input",
        "mission": {
            "name": "Module Missing Workspace Key",
            "description": "A module receives its environment name from a workspace-keyed map, but the current workspace is not in the map.",
            "objective": "Add the missing workspace key to the map so the module input resolves and `terraform plan` passes.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["workspace module inputs", "map lookup", "module variables"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "modules/writer/terraform.tf": LOCAL_ONLY_TF,
            "modules/writer/main.tf": """\
variable "env" {
  type = string
}

variable "output_dir" {
  type = string
}

resource "local_file" "marker" {
  content  = "deployed to: ${var.env}"
  filename = "${var.output_dir}/${var.env}-marker.txt"
}

output "marker_path" {
  value = local_file.marker.filename
}
""",
            "main.tf": """\
# The env_map is missing the "default" workspace key.
# Fix: add "default" = "development" to the env_map.

locals {
  env_map = {
    staging    = "staging"
    production = "production"
  }
}

module "writer" {
  source     = "./modules/writer"
  env        = local.env_map[terraform.workspace]
  output_dir = path.module
}

output "path" {
  value = module.writer.marker_path
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "modules/writer/terraform.tf": LOCAL_ONLY_TF,
            "modules/writer/main.tf": """\
variable "env" {
  type = string
}

variable "output_dir" {
  type = string
}

resource "local_file" "marker" {
  content  = "deployed to: ${var.env}"
  filename = "${var.output_dir}/${var.env}-marker.txt"
}

output "marker_path" {
  value = local_file.marker.filename
}
""",
            "main.tf": """\
locals {
  env_map = {
    default    = "development"
    staging    = "staging"
    production = "production"
  }
}

module "writer" {
  source     = "./modules/writer"
  env        = local.env_map[terraform.workspace]
  output_dir = path.module
}

output "path" {
  value = module.writer.marker_path
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. Terraform reports a key error because `local.env_map[\"default\"]` does not exist. The current workspace is `default`.",
            "The `env_map` local needs an entry for every workspace you plan to use, including `default`.",
            "Add `default = \"development\"` to the `env_map` in the `locals` block.",
        ],
        "debrief": """\
# Module Missing Workspace Key

## What Was Broken
The `env_map` was missing the `"default"` key. When running in the default workspace,
`local.env_map[terraform.workspace]` resolves to `local.env_map["default"]`, which
does not exist.

## The Fix
```hcl
locals {
  env_map = {
    default    = "development"
    staging    = "staging"
    production = "production"
  }
}
```

## Passing Workspace-Derived Values to Modules
```hcl
module "app" {
  source = "./modules/app"
  env    = local.env_map[terraform.workspace]
}
```

This is a clean pattern — the root module handles workspace-to-environment translation,
and the child module only knows about `var.env`.

## Alternative with try()
```hcl
env = try(local.env_map[terraform.workspace], "development")
```
""",
        "common_mistakes": """\
# Common Mistakes

- **Missing `default` key** — the most common oversight; always include `default` as a fallback.
- **Passing `terraform.workspace` directly to modules** — modules should not need to know about workspaces; translate at the root level.
- **Inconsistent env names** — agree on a convention (`dev`/`stg`/`prd` vs `development`/`staging`/`production`) and stick to it.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 10 — workspace-list-select
# ─────────────────────────────────────────────────────────────────────────────
def _level_10_workspace_list_select():
    return {
        "module": MODULE,
        "slug": "level-10-workspace-list-select",
        "mission": {
            "name": "Variable Default Missing",
            "description": "A variable used to hold the workspace name has no default value, causing `terraform plan` to require interactive input.",
            "objective": "Add `default = \"default\"` to the variable so `terraform plan` works non-interactively.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["workspace commands", "variable default", "non-interactive plan"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# var.workspace_name has no default, so terraform plan prompts for input.
# Fix: add default = "default" to the variable.

variable "workspace_name" {
  type        = string
  description = "The name of the current workspace"
}

resource "local_file" "info" {
  content  = "workspace: ${var.workspace_name} / actual: ${terraform.workspace}"
  filename = "${path.module}/workspace-info.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "workspace_name" {
  type        = string
  description = "The name of the current workspace"
  default     = "default"
}

resource "local_file" "info" {
  content  = "workspace: ${var.workspace_name} / actual: ${terraform.workspace}"
  filename = "${path.module}/workspace-info.txt"
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# Create a test workspace, plan, then clean up
terraform workspace new test-ws-level10 > /dev/null 2>&1 || true

if terraform plan -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    echo "✅ PASS: terraform plan succeeded without interactive input"
    terraform workspace select default > /dev/null 2>&1
    terraform workspace delete test-ws-level10 > /dev/null 2>&1 || true
    exit 0
fi

cat /tmp/tf_out.txt
terraform workspace select default > /dev/null 2>&1 || true
terraform workspace delete test-ws-level10 > /dev/null 2>&1 || true
echo "❌ FAIL: terraform plan failed or required interactive input"
exit 1
"""),
        "hints": [
            "Run `terraform plan -input=false`. It fails because `var.workspace_name` has no default and cannot be resolved without user input.",
            "Variables without defaults require input at runtime. For workspace-aware tooling, provide a sensible default so plans run non-interactively.",
            "Add `default = \"default\"` to the `variable \"workspace_name\"` block.",
        ],
        "debrief": """\
# Variable Default Missing

## What Was Broken
`var.workspace_name` had no `default` value. Running `terraform plan -input=false` (as CI/CD
systems typically do) caused an immediate error because Terraform could not prompt for the value.

## The Fix
```hcl
variable "workspace_name" {
  type    = string
  default = "default"
}
```

## Workspace Commands
```bash
terraform workspace list          # list all workspaces
terraform workspace new staging   # create and switch to "staging"
terraform workspace select default # switch back to default
terraform workspace show          # print current workspace name
terraform workspace delete staging # delete a workspace (must not be active)
```

## Note on Variable vs terraform.workspace
This pattern (storing `terraform.workspace` in a variable) is mostly educational.
In real configs, read `terraform.workspace` directly rather than using an intermediary variable.
""",
        "common_mistakes": """\
# Common Mistakes

- **No default on required variables** — always provide defaults for variables used in automated workflows.
- **Using a variable instead of `terraform.workspace`** — prefer the built-in directly; it is always available and always correct.
- **Not cleaning up test workspaces** — workspaces accumulate; delete them when done with `terraform workspace delete`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 11 — workspace-destroy-order
# ─────────────────────────────────────────────────────────────────────────────
def _level_11_workspace_destroy_order():
    return {
        "module": MODULE,
        "slug": "level-11-workspace-destroy-order",
        "mission": {
            "name": "Wrong Dependency Path",
            "description": "Resource B reads a file created by resource A, but the path uses a hardcoded workspace name instead of `terraform.workspace`, breaking the reference in all workspaces except `default`.",
            "objective": "Fix the path in resource B to use `terraform.workspace` so the reference resolves correctly in any workspace and `terraform plan` passes.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["workspace resource ordering", "terraform.workspace in paths", "depends_on"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Resource B reads the file created by resource A.
# The filename in resource B is hardcoded to "default-data.txt" instead of using
# terraform.workspace, so it only works in the default workspace.
# Fix: change "default-data.txt" to "${terraform.workspace}-data.txt"

resource "local_file" "resource_a" {
  content  = "data from resource A in workspace ${terraform.workspace}"
  filename = "${path.module}/${terraform.workspace}-data.txt"
}

resource "local_file" "resource_b" {
  content    = "resource B referencing: ${path.module}/default-data.txt"
  filename   = "${path.module}/${terraform.workspace}-output.txt"
  depends_on = [local_file.resource_a]
}

output "b_content" {
  value = local_file.resource_b.content
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "resource_a" {
  content  = "data from resource A in workspace ${terraform.workspace}"
  filename = "${path.module}/${terraform.workspace}-data.txt"
}

resource "local_file" "resource_b" {
  content    = "resource B referencing: ${path.module}/${terraform.workspace}-data.txt"
  filename   = "${path.module}/${terraform.workspace}-output.txt"
  depends_on = [local_file.resource_a]
}

output "b_content" {
  value = local_file.resource_b.content
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. Resource B's content hardcodes `default-data.txt` instead of using `terraform.workspace`. In any workspace other than `default`, this path is wrong.",
            "Resource A writes to `${terraform.workspace}-data.txt`. Resource B should reference the same workspace-aware filename.",
            "Change `\"${path.module}/default-data.txt\"` to `\"${path.module}/${terraform.workspace}-data.txt\"` in resource B's content.",
        ],
        "debrief": """\
# Wrong Dependency Path

## What Was Broken
Resource B's content contained a hardcoded reference to `default-data.txt`. This breaks
immediately in any workspace other than `default` because resource A writes to
`${terraform.workspace}-data.txt`, not `default-data.txt`.

## The Fix
```hcl
resource "local_file" "resource_b" {
  content    = "resource B referencing: ${path.module}/${terraform.workspace}-data.txt"
  filename   = "${path.module}/${terraform.workspace}-output.txt"
  depends_on = [local_file.resource_a]
}
```

## Key Principle
Any path, name, or identifier that is workspace-specific must use `terraform.workspace`.
Hardcoding workspace names defeats the purpose of workspaces.

## The depends_on Pattern
When resource B logically depends on resource A but does not reference its attributes
directly, use `depends_on` to enforce ordering:
```hcl
depends_on = [local_file.resource_a]
```
""",
        "common_mistakes": """\
# Common Mistakes

- **Hardcoding workspace names in paths** — always use `terraform.workspace` for workspace-specific paths.
- **Missing `depends_on`** — implicit file dependencies need explicit ordering.
- **Assuming the default workspace** — code should work correctly in all workspaces, not just `default`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 12 — workspace-vs-state-files
# ─────────────────────────────────────────────────────────────────────────────
def _level_12_workspace_vs_state_files():
    return {
        "module": MODULE,
        "slug": "level-12-workspace-vs-state-files",
        "mission": {
            "name": "Invalid Backend Interpolation",
            "description": "The backend block uses `${terraform.workspace}` inside the path, which is not allowed. Backend blocks must have static configuration.",
            "objective": "Remove the interpolation from the backend block so `terraform init` succeeds.",
            "xp": 250,
            "difficulty": "intermediate",
            "expected_time": "18m",
            "concepts": ["workspace vs separate state files", "backend limitations", "static backend config"],
        },
        "broken": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  # Invalid: backend blocks cannot use interpolation or expressions.
  # terraform.workspace is not available during backend initialisation.
  backend "local" {
    path = "workspaces/${terraform.workspace}/terraform.tfstate"
  }
}
""",
            "main.tf": """\
resource "local_file" "example" {
  content  = "workspace example"
  filename = "${path.module}/example.txt"
}
""",
        },
        "solution": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  # Static backend path — Terraform workspaces handle state isolation automatically.
  # Non-default workspaces store state in terraform.tfstate.d/<workspace>/terraform.tfstate
  backend "local" {
    path = "terraform.tfstate"
  }
}
""",
            "main.tf": """\
resource "local_file" "example" {
  content  = "workspace example"
  filename = "${path.module}/example.txt"
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if terraform init -no-color -input=false -reconfigure 2>&1; then
    echo "✅ PASS: terraform init succeeded with static backend config"
    exit 0
fi
echo "❌ FAIL: terraform init failed — check the backend block for interpolation"
exit 1
"""),
        "hints": [
            "Run `terraform init`. It fails with an error about interpolation in the backend block. Backend configuration is evaluated before the Terraform language engine starts.",
            "Terraform workspaces already store state in separate locations automatically. For a local backend, state is kept at `terraform.tfstate.d/<workspace>/terraform.tfstate` without any manual path manipulation.",
            "Remove the dynamic path and replace it with a static value: `path = \"terraform.tfstate\"`. Terraform will manage workspace state files automatically.",
        ],
        "debrief": """\
# Invalid Backend Interpolation

## What Was Broken
The backend block used `${terraform.workspace}` in the path. Backend configuration is parsed
before the Terraform runtime starts — at that point, `terraform.workspace` does not exist yet.
Interpolation is simply not allowed in backend blocks.

## The Fix
```hcl
backend "local" {
  path = "terraform.tfstate"
}
```

## How Workspace State Isolation Works Automatically
| Workspace   | State file location |
|------------|---------------------|
| `default`  | `./terraform.tfstate` (or configured `path`) |
| `staging`  | `./terraform.tfstate.d/staging/terraform.tfstate` |
| `production` | `./terraform.tfstate.d/production/terraform.tfstate` |

Terraform handles this **automatically** — you do not need to encode workspace names in the path.

## When to Use Separate State Files (not workspaces)
For truly separate environments (different accounts, different providers), separate Terraform
root modules with separate state files and separate backends is safer than workspaces.
Workspaces share the same provider config and are best for small environmental differences.

## Key Rule
Backend blocks: **literal values only**. No variables, no locals, no expressions.
Use `-backend-config` CLI flags for dynamic backend configuration.
""",
        "common_mistakes": """\
# Common Mistakes

- **Interpolation in backend** — this is a very common mistake; always use static strings in backend blocks.
- **Manually managing workspace paths** — Terraform handles workspace state separation; don't fight it.
- **Using workspaces for fundamentally different environments** — if `staging` and `production` have different providers or accounts, use separate root modules instead.
- **Forgetting `-reconfigure` after fixing backend** — after fixing the backend block, run `terraform init -reconfigure` to reinitialise.
""",
    }


if __name__ == "__main__":
    build()
