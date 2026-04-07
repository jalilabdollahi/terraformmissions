#!/usr/bin/env python3
"""Module 12 — Advanced HCL Patterns (20 levels, Advanced)."""
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

MODULE = "module-12-advanced-patterns"


def build() -> int:
    levels = [
        _level_01_provider_alias_multi(),
        _level_02_provider_meta_argument(),
        _level_03_create_before_destroy(),
        _level_04_replace_triggered_by(),
        _level_05_moved_block_rename(),
        _level_06_moved_block_module(),
        _level_07_moved_block_for_each(),
        _level_08_removed_block(),
        _level_09_import_block_address(),
        _level_10_import_block_id(),
        _level_11_postcondition_output(),
        _level_12_precondition_resource(),
        _level_13_dynamic_nested_block(),
        _level_14_check_block(),
        _level_15_ephemeral_pattern(),
        _level_16_lifecycle_ignore_all(),
        _level_17_custom_condition(),
        _level_18_provider_version_lock(),
        _level_19_complex_refactor(),
        _level_20_identity_token(),
    ]
    for lvl in levels:
        write_level(lvl)
    print_done(MODULE, len(levels))
    return len(levels)


# ─────────────────────────────────────────────────────────────────────────────
# Level 1 — provider-alias-multi
# ─────────────────────────────────────────────────────────────────────────────
def _level_01_provider_alias_multi():
    return {
        "module": MODULE,
        "slug": "level-1-provider-alias-multi",
        "mission": {
            "name": "Alias Confusion",
            "description": (
                "Two `provider \"local\"` blocks exist — one aliased `primary` and one aliased `secondary`. "
                "A resource references `provider = local.wrong`, which doesn't exist."
            ),
            "objective": "Fix the provider reference so the resource uses `provider = local.primary`.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["provider aliases", "provider meta-argument"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
provider "local" {
  alias = "primary"
}

provider "local" {
  alias = "secondary"
}

# Bug: references a non-existent alias "wrong"
resource "local_file" "config" {
  provider = local.wrong

  content  = "primary config"
  filename = "${path.module}/config.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
provider "local" {
  alias = "primary"
}

provider "local" {
  alias = "secondary"
}

resource "local_file" "config" {
  provider = local.primary

  content  = "primary config"
  filename = "${path.module}/config.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error will mention an unknown provider configuration. Look at the `provider =` line inside the resource.",
            "The two provider blocks define aliases `primary` and `secondary`. The resource references `local.wrong` — this alias does not exist.",
            "Change `provider = local.wrong` to `provider = local.primary` to reference the correct aliased provider.",
        ],
        "debrief": """\
# Alias Confusion

## What Was Broken
The resource block used `provider = local.wrong`, but no provider with alias `wrong` was declared.
Only `local.primary` and `local.secondary` existed.

## The Fix
Change the `provider` meta-argument to reference a valid alias:
```hcl
provider = local.primary
```

## Provider Alias Pattern
When you declare multiple provider blocks of the same type, each (except one) must have an `alias`.
Resources then opt into a specific configuration using `provider = <type>.<alias>`.

## Why It Matters
Provider aliases are essential for multi-region or multi-account deployments. Getting the alias wrong
causes a validation error before any infrastructure is touched.
""",
        "common_mistakes": """\
# Common Mistakes

- **Typo in alias name** — `local.wrong` instead of `local.primary`. Copy the exact alias string from the provider block.
- **Omitting the `provider` meta-argument** — when multiple aliased providers exist, Terraform uses the default (un-aliased) one. If there is no default, an error occurs.
- **Confusing `provider` (meta-argument) with `required_providers`** — these are different concepts.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 2 — provider-meta-argument
# ─────────────────────────────────────────────────────────────────────────────
def _level_02_provider_meta_argument():
    return {
        "module": MODULE,
        "slug": "level-2-provider-meta-argument",
        "mission": {
            "name": "String vs Reference",
            "description": (
                "A resource sets `provider = \"local.primary\"` using a string literal. "
                "Terraform requires a provider reference (not a string) for this meta-argument."
            ),
            "objective": "Fix the `provider` meta-argument syntax from a string to a proper reference.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["provider meta-argument syntax", "provider aliases"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
provider "local" {
  alias = "primary"
}

# Bug: provider value is a string, not a reference
resource "local_file" "app_config" {
  provider = "local.primary"

  content  = "environment=production"
  filename = "${path.module}/app.cfg"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
provider "local" {
  alias = "primary"
}

resource "local_file" "app_config" {
  provider = local.primary

  content  = "environment=production"
  filename = "${path.module}/app.cfg"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. Look for an error about an invalid expression type on the `provider` argument.",
            "The `provider` meta-argument expects a reference in the form `<provider_type>.<alias>` — not a quoted string.",
            "Remove the quotes: change `provider = \"local.primary\"` to `provider = local.primary`.",
        ],
        "debrief": """\
# String vs Reference

## What Was Broken
`provider = "local.primary"` is a string literal. Terraform expects a provider configuration
reference, which is written without quotes: `provider = local.primary`.

## The Fix
```hcl
# Wrong
provider = "local.primary"

# Correct
provider = local.primary
```

## Why It Matters
Terraform uses a distinct syntax for provider references to distinguish them from string values.
This is consistent with how resource references work elsewhere in HCL — they are bare identifiers,
not strings.
""",
        "common_mistakes": """\
# Common Mistakes

- **Quoting the provider reference** — `"local.primary"` is treated as a string, not a provider reference.
- **Using interpolation** — `"${local.primary}"` is also incorrect; the value must be an unquoted reference.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 3 — create-before-destroy
# ─────────────────────────────────────────────────────────────────────────────
def _level_03_create_before_destroy():
    return {
        "module": MODULE,
        "slug": "level-3-create-before-destroy",
        "mission": {
            "name": "Name Collision on Replacement",
            "description": (
                "Two resources share the same static filename and both use `create_before_destroy = true`. "
                "When Terraform tries to replace them, a name collision occurs."
            ),
            "objective": "Make the filenames unique so that replacement succeeds without collision.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["create_before_destroy", "lifecycle", "resource naming"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Bug: both resources write to the same filename with create_before_destroy = true.
# On replacement, the new resource tries to create the file before the old one is destroyed,
# causing a collision.

resource "local_file" "config_a" {
  content  = "config A"
  filename = "${path.module}/shared.txt"

  lifecycle {
    create_before_destroy = true
  }
}

resource "local_file" "config_b" {
  content  = "config B"
  filename = "${path.module}/shared.txt"

  lifecycle {
    create_before_destroy = true
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config_a" {
  content  = "config A"
  filename = "${path.module}/config-a.txt"

  lifecycle {
    create_before_destroy = true
  }
}

resource "local_file" "config_b" {
  content  = "config B"
  filename = "${path.module}/config-b.txt"

  lifecycle {
    create_before_destroy = true
  }
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "The issue is that both resources try to use the same `filename`. With `create_before_destroy`, the new instance is created before the old one is destroyed.",
            "When two resources share a filename and one must be created before the other is destroyed, the filesystem will complain about the file already existing.",
            "Give each resource a unique filename: `config-a.txt` and `config-b.txt`.",
        ],
        "debrief": """\
# Name Collision on Replacement

## What Was Broken
Both `local_file.config_a` and `local_file.config_b` pointed to the same `filename = "shared.txt"`.
With `create_before_destroy = true`, Terraform creates the new instance before deleting the old one.
When the filename is the same, the new instance collides with the existing file.

## The Fix
Give each resource a unique filename so they do not compete for the same path.

## create_before_destroy Semantics
- Normally: destroy old → create new
- With `create_before_destroy`: create new → destroy old (requires unique identifiers)

## Why It Matters
`create_before_destroy` is useful for avoiding downtime but requires that new resources can coexist
with old ones momentarily. Static, shared identifiers break this invariant.
""",
        "common_mistakes": """\
# Common Mistakes

- **Assuming `create_before_destroy` is always safe** — it requires unique resource identifiers.
- **Using a static shared name** — if two resources share the same unique identifier, a collision is unavoidable.
- **Forgetting that `local_file` is filesystem-backed** — the filename IS the unique identifier for the provider.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 4 — replace-triggered-by
# ─────────────────────────────────────────────────────────────────────────────
def _level_04_replace_triggered_by():
    return {
        "module": MODULE,
        "slug": "level-4-replace-triggered-by",
        "mission": {
            "name": "Triggered by Nothing",
            "description": (
                "A lifecycle block uses `replace_triggered_by = [null_resource.wrong_ref]`, "
                "but no resource named `null_resource.wrong_ref` exists in the configuration."
            ),
            "objective": "Fix the `replace_triggered_by` to reference a resource that actually exists.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["replace_triggered_by", "lifecycle", "resource references"],
        },
        "broken": {
            "terraform.tf": DEFAULT_TERRAFORM_TF,
            "main.tf": """\
resource "null_resource" "trigger" {
  triggers = {
    version = "v1"
  }
}

# Bug: references null_resource.wrong_ref which does not exist
resource "local_file" "config" {
  content  = "triggered config"
  filename = "${path.module}/config.txt"

  lifecycle {
    replace_triggered_by = [null_resource.wrong_ref]
  }
}
""",
        },
        "solution": {
            "terraform.tf": DEFAULT_TERRAFORM_TF,
            "main.tf": """\
resource "null_resource" "trigger" {
  triggers = {
    version = "v1"
  }
}

resource "local_file" "config" {
  content  = "triggered config"
  filename = "${path.module}/config.txt"

  lifecycle {
    replace_triggered_by = [null_resource.trigger]
  }
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error reports a reference to an undeclared resource.",
            "Look at the `replace_triggered_by` list — it references `null_resource.wrong_ref`. Does that resource exist in your config?",
            "Change `null_resource.wrong_ref` to `null_resource.trigger`, which is the resource declared at the top of the file.",
        ],
        "debrief": """\
# Triggered by Nothing

## What Was Broken
`replace_triggered_by = [null_resource.wrong_ref]` references a resource label `wrong_ref` that
does not exist. Terraform validates all references during `terraform validate`.

## The Fix
```hcl
lifecycle {
  replace_triggered_by = [null_resource.trigger]
}
```

## replace_triggered_by
This lifecycle argument forces replacement of the resource when any of the listed resources change.
All listed resources must be declared in the same configuration.

## Why It Matters
Dangling references are caught at validate/plan time, not at apply time. Always ensure every
resource reference points to a declared resource.
""",
        "common_mistakes": """\
# Common Mistakes

- **Referencing the wrong resource label** — copy the exact label from the `resource` declaration.
- **Confusing `replace_triggered_by` with `depends_on`** — `replace_triggered_by` causes replacement; `depends_on` only affects ordering.
- **Listing attributes instead of resources** — the list contains resource references, not attribute paths.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 5 — moved-block-rename
# ─────────────────────────────────────────────────────────────────────────────
def _level_05_moved_block_rename():
    return {
        "module": MODULE,
        "slug": "level-5-moved-block-rename",
        "mission": {
            "name": "Moving in the Wrong Direction",
            "description": (
                "A resource was renamed from `local_file.old` to `local_file.new`, but the `moved` block "
                "has `from` and `to` swapped — it points from `new` to `old` instead of the correct direction."
            ),
            "objective": "Fix the `moved` block so Terraform maps the old state address to the new resource name without destroying and recreating.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["moved block", "state refactoring", "resource renaming"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "new" {
  content  = "renamed resource"
  filename = "${path.module}/output.txt"
}

# Bug: from/to are swapped — should be from=old, to=new
moved {
  from = local_file.new
  to   = local_file.old
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "new" {
  content  = "renamed resource"
  filename = "${path.module}/output.txt"
}

moved {
  from = local_file.old
  to   = local_file.new
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The error says that `local_file.old` is not declared. Check the `moved` block's `to` value.",
            "A `moved` block maps an old address (`from`) to a new address (`to`). The `to` must match a declared resource; `from` is the historical state address.",
            "Swap the addresses: `from = local_file.old` and `to = local_file.new`.",
        ],
        "debrief": """\
# Moving in the Wrong Direction

## What Was Broken
The `moved` block had `from = local_file.new` and `to = local_file.old`. This tells Terraform
to look for `local_file.new` in state and rename it to `local_file.old`. But `local_file.old`
is not declared in the config — only `local_file.new` is. The direction was backwards.

## The Fix
```hcl
moved {
  from = local_file.old   # previous state address
  to   = local_file.new   # current config address
}
```

## moved Block Semantics
- `from`: the address that exists in the **current state** (before this change)
- `to`: the address in the **current config** (after this change)

## Why It Matters
A reversed `moved` block causes Terraform to plan a destroy+create instead of an in-place rename,
potentially losing production resources.
""",
        "common_mistakes": """\
# Common Mistakes

- **Swapping from/to** — `from` is the old name in state, `to` is the new name in config.
- **Forgetting the `moved` block entirely** — without it, Terraform plans a destroy+create.
- **Using `moved` for type changes** — `moved` only handles address changes, not resource type changes.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 6 — moved-block-module
# ─────────────────────────────────────────────────────────────────────────────
def _level_06_moved_block_module():
    return {
        "module": MODULE,
        "slug": "level-6-moved-block-module",
        "mission": {
            "name": "Module Migration Mismatch",
            "description": (
                "A `moved` block migrates a resource into a child module, but the module name in the `to` "
                "address is wrong — it says `module.wrong_module` instead of `module.storage`."
            ),
            "objective": "Fix the `moved` block's `to` address to use the correct module name.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["moved to module", "module addresses", "state refactoring"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "storage" {
  source = "./modules/storage"
}

# Bug: 'to' references module.wrong_module which doesn't exist
moved {
  from = local_file.config
  to   = module.wrong_module.local_file.config
}
""",
            "modules/storage/main.tf": """\
resource "local_file" "config" {
  content  = "stored config"
  filename = "${path.module}/config.txt"
}
""",
            "modules/storage/terraform.tf": LOCAL_ONLY_TF,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "storage" {
  source = "./modules/storage"
}

moved {
  from = local_file.config
  to   = module.storage.local_file.config
}
""",
            "modules/storage/main.tf": """\
resource "local_file" "config" {
  content  = "stored config"
  filename = "${path.module}/config.txt"
}
""",
            "modules/storage/terraform.tf": LOCAL_ONLY_TF,
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. Look for an error about an undeclared module. Check the `to` address in the `moved` block.",
            "The module is declared as `module \"storage\"` but the `moved` block references `module.wrong_module`. These must match.",
            "Change `module.wrong_module.local_file.config` to `module.storage.local_file.config`.",
        ],
        "debrief": """\
# Module Migration Mismatch

## What Was Broken
`moved { to = module.wrong_module.local_file.config }` references `module.wrong_module`, but the
only declared module is `module "storage"`. Terraform cannot resolve the destination address.

## The Fix
```hcl
moved {
  from = local_file.config
  to   = module.storage.local_file.config
}
```

## Module Address Format
When moving a resource into a module, the `to` address follows the pattern:
```
module.<module_label>.<resource_type>.<resource_label>
```

## Why It Matters
Moving resources into modules is a common refactoring step when growing a Terraform codebase.
Getting the module address wrong causes Terraform to plan a destroy+create cycle instead of a
safe in-place move.
""",
        "common_mistakes": """\
# Common Mistakes

- **Wrong module label** — the label in `module.X` must match the `module "X"` declaration exactly.
- **Missing intermediate module path** — for nested modules, the full path must be specified: `module.outer.module.inner.resource_type.label`.
- **Omitting the resource type** — the full address includes `module.<label>.<type>.<resource_label>`, not just the resource label.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 7 — moved-block-for-each
# ─────────────────────────────────────────────────────────────────────────────
def _level_07_moved_block_for_each():
    return {
        "module": MODULE,
        "slug": "level-7-moved-block-for-each",
        "mission": {
            "name": "Key Quoting in moved Block",
            "description": (
                "A `moved` block migrates `local_file.items[0]` (count-based) to "
                "`local_file.items[\"primary\"]` (for_each-based), but the string key `primary` "
                "is missing its quotes."
            ),
            "objective": "Add the missing quotes around the for_each instance key in the `moved` block.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["moved with for_each instance keys", "count to for_each migration", "address syntax"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "items" {
  for_each = toset(["primary"])
  content  = "item ${each.key}"
  filename = "${path.module}/item-${each.key}.txt"
}

# Bug: "primary" key is missing quotes in the moved block
moved {
  from = local_file.items[0]
  to   = local_file.items[primary]
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "items" {
  for_each = toset(["primary"])
  content  = "item ${each.key}"
  filename = "${path.module}/item-${each.key}.txt"
}

moved {
  from = local_file.items[0]
  to   = local_file.items["primary"]
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform validate`. The error points to the `moved` block's `to` line — look at `local_file.items[primary]`.",
            "When a resource uses `for_each` with string keys, the instance address uses quoted strings: `resource_type.label[\"key\"]`.",
            "Add double quotes around `primary`: change `local_file.items[primary]` to `local_file.items[\"primary\"]`.",
        ],
        "debrief": """\
# Key Quoting in moved Block

## What Was Broken
`local_file.items[primary]` uses an unquoted identifier `primary` as an instance key.
For `for_each` resources with string keys, the key must be quoted: `local_file.items["primary"]`.

## The Fix
```hcl
moved {
  from = local_file.items[0]
  to   = local_file.items["primary"]
}
```

## Instance Address Syntax
| Instance type | Address format |
|---|---|
| `count` | `resource_type.label[0]` |
| `for_each` (string key) | `resource_type.label["key"]` |
| `for_each` (number key) | `resource_type.label[42]` |

## Why It Matters
count-to-for_each migration is one of the most common Terraform refactoring patterns.
The `moved` block makes this safe by preserving state, but the address syntax must be exact.
""",
        "common_mistakes": """\
# Common Mistakes

- **Unquoted string keys** — `[primary]` is not valid; string keys always need quotes `["primary"]`.
- **Confusing count index with for_each key** — `[0]` is a count index; `["primary"]` is a for_each key.
- **Wrong key value** — the `to` key must exactly match the `for_each` key in the new config.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 8 — removed-block
# ─────────────────────────────────────────────────────────────────────────────
def _level_08_removed_block():
    return {
        "module": MODULE,
        "slug": "level-8-removed-block",
        "mission": {
            "name": "Ghost Resource",
            "description": (
                "A `removed` block is used to tell Terraform to forget about `local_file.old` without "
                "destroying it, but the resource is still declared in the config — causing a conflict."
            ),
            "objective": "Remove the `resource` block for `local_file.old` from the config, keeping only the `removed` block.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["removed block", "TF 1.7+", "state management"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Bug: local_file.old is both declared as a resource AND listed in a removed block.
# Terraform 1.7+ requires the resource to be absent from config when using 'removed'.

resource "local_file" "old" {
  content  = "legacy content"
  filename = "${path.module}/old.txt"
}

removed {
  from = local_file.old

  lifecycle {
    destroy = false
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# The resource block for local_file.old has been removed from config.
# The 'removed' block instructs Terraform to remove it from state without destroying the file.

removed {
  from = local_file.old

  lifecycle {
    destroy = false
  }
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The error says the `removed` block conflicts with the existing resource declaration.",
            "The `removed` block is used AFTER you have already deleted the `resource` block from your config. It handles the state cleanup.",
            "Delete the entire `resource \"local_file\" \"old\"` block, leaving only the `removed` block.",
        ],
        "debrief": """\
# Ghost Resource

## What Was Broken
A `removed` block and a `resource` block for the same address cannot coexist. The `removed` block
is specifically designed for the transition period after you delete the `resource` block — it tells
Terraform what to do with the existing state entry.

## The Fix
Delete the `resource "local_file" "old" { ... }` block. The `removed` block alone is sufficient.

## removed Block (Terraform 1.7+)
```hcl
removed {
  from = local_file.old
  lifecycle {
    destroy = false  # keep the real file; just forget it in state
  }
}
```

## Why It Matters
Without a `removed` block, deleting a resource from config causes Terraform to destroy the real
infrastructure. The `removed` block gives you a safe off-ramp: remove from state without destroying.
""",
        "common_mistakes": """\
# Common Mistakes

- **Leaving the resource block in config** — the resource must be removed before `removed` can work.
- **Using `removed` on Terraform < 1.7** — this feature was introduced in Terraform 1.7.
- **Setting `destroy = true` unintentionally** — `destroy = false` preserves the real resource; `destroy = true` destroys it.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 9 — import-block-address
# ─────────────────────────────────────────────────────────────────────────────
def _level_09_import_block_address():
    return {
        "module": MODULE,
        "slug": "level-9-import-block-address",
        "mission": {
            "name": "Wrong Import Destination",
            "description": (
                "An `import` block uses `to = module.storage.local_file.config`, but the `module.storage` "
                "module does not exist in this configuration. The resource should be imported directly."
            ),
            "objective": "Fix the `import` block's `to` address to point to `local_file.config` directly.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["import block address format", "TF 1.5+", "importing resources"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Bug: to = module.storage.local_file.config references a non-existent module
import {
  to = module.storage.local_file.config
  id = "${path.module}/config.txt"
}

resource "local_file" "config" {
  content  = "imported content"
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
  content  = "imported content"
  filename = "${path.module}/config.txt"
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The error mentions an undeclared module `storage`. Check the `import` block's `to` value.",
            "The `to` address must point to a resource that is declared in the current configuration. There is no `module \"storage\"` block.",
            "Change `to = module.storage.local_file.config` to `to = local_file.config` to match the declared resource.",
        ],
        "debrief": """\
# Wrong Import Destination

## What Was Broken
`import { to = module.storage.local_file.config }` references `module.storage`, which is not
declared anywhere in the configuration.

## The Fix
```hcl
import {
  to = local_file.config
  id = "${path.module}/config.txt"
}
```

## import Block (Terraform 1.5+)
The `to` address must resolve to a resource declared in the **current** configuration.
The `id` is the provider-specific import ID for the real resource.

## Why It Matters
The `import` block is the modern, code-review-friendly alternative to `terraform import` CLI.
An incorrect `to` address means the import targets nothing and fails at plan time.
""",
        "common_mistakes": """\
# Common Mistakes

- **Referencing a non-existent module in `to`** — the module must be declared if used in the address.
- **Confusing `to` address with state path** — `to` is a config-side address, not a state path.
- **Wrong `id` format** — the `id` must match what the provider uses to identify the resource.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 10 — import-block-id
# ─────────────────────────────────────────────────────────────────────────────
def _level_10_import_block_id():
    return {
        "module": MODULE,
        "slug": "level-10-import-block-id",
        "mission": {
            "name": "ID Type Mismatch",
            "description": (
                "An `import` block provides `id = 12345` as a number literal. "
                "The `id` argument must always be a string."
            ),
            "objective": "Fix the `id` in the `import` block to be a valid string path.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["import id type", "import block", "provider ID format"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Bug: id is a number (12345) — import id must always be a string
import {
  to = local_file.config
  id = 12345
}

resource "local_file" "config" {
  content  = "imported content"
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
  content  = "imported content"
  filename = "${path.module}/config.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error indicates that the `id` argument is the wrong type — it expects a string.",
            "The `id` in an `import` block is always a string. For `local_file`, the ID is the file path.",
            "Change `id = 12345` to `id = \"${path.module}/config.txt\"` to use the file path as the import ID.",
        ],
        "debrief": """\
# ID Type Mismatch

## What Was Broken
`id = 12345` provides a number where a string is required. The `import` block's `id` argument
is always of type `string`.

## The Fix
```hcl
import {
  to = local_file.config
  id = "${path.module}/config.txt"
}
```

## Import ID Conventions
- `local_file`: the ID is the absolute file path
- `aws_instance`: the ID is the instance ID (e.g., `"i-1234567890abcdef0"`)
- Always consult the provider documentation for the correct ID format

## Why It Matters
Using the wrong ID type causes a validation error. Using the wrong ID value causes the import
to fail at plan/apply time with a "resource not found" error from the provider.
""",
        "common_mistakes": """\
# Common Mistakes

- **Numeric ID instead of string** — `id = 12345` vs `id = "12345"`.
- **Wrong ID format for the provider** — check provider docs for the exact format.
- **Using the resource name as ID** — the ID is a provider-side identifier, not the Terraform label.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 11 — postcondition-output
# ─────────────────────────────────────────────────────────────────────────────
def _level_11_postcondition_output():
    return {
        "module": MODULE,
        "slug": "level-11-postcondition-output",
        "mission": {
            "name": "Self-Referential Error",
            "description": (
                "An output block has a `postcondition` that uses `self.wrong_attr` — "
                "but the correct attribute for an output's self reference is `self.value`."
            ),
            "objective": "Fix the postcondition to use `self.value` instead of `self.wrong_attr`.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["output postcondition", "self reference", "lifecycle conditions"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "app config"
  filename = "${path.module}/config.txt"
}

output "config_path" {
  value = local_file.config.filename

  # Bug: self.wrong_attr does not exist; should be self.value
  lifecycle {
    postcondition {
      condition     = self.wrong_attr != ""
      error_message = "Config path must not be empty."
    }
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "app config"
  filename = "${path.module}/config.txt"
}

output "config_path" {
  value = local_file.config.filename

  lifecycle {
    postcondition {
      condition     = self.value != ""
      error_message = "Config path must not be empty."
    }
  }
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The error points to `self.wrong_attr` inside the postcondition.",
            "Inside an output's `postcondition`, `self` refers to the output itself. The output has one attribute accessible via `self`: `self.value`.",
            "Change `self.wrong_attr` to `self.value`.",
        ],
        "debrief": """\
# Self-Referential Error

## What Was Broken
`self.wrong_attr` references an attribute that does not exist. Inside an output's `postcondition`,
`self` exposes only `self.value` — the value of the output.

## The Fix
```hcl
postcondition {
  condition     = self.value != ""
  error_message = "Config path must not be empty."
}
```

## self in Conditions
| Context | self refers to |
|---|---|
| `resource lifecycle precondition/postcondition` | the resource instance |
| `output lifecycle postcondition` | the output value object |

For outputs, `self.value` is the only available attribute.

## Why It Matters
Custom conditions are powerful for encoding assumptions about your infrastructure. An invalid
`self` reference prevents the condition from running at all.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using resource attributes on `self` in output conditions** — `self` in an output postcondition only has `value`.
- **Confusing `self` with the resource reference** — use the full reference path outside of condition blocks.
- **Missing `lifecycle` wrapper** — the `postcondition` block must be inside a `lifecycle` block.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 12 — precondition-resource
# ─────────────────────────────────────────────────────────────────────────────
def _level_12_precondition_resource():
    return {
        "module": MODULE,
        "slug": "level-12-precondition-resource",
        "mission": {
            "name": "Too Strict a Gate",
            "description": (
                "A resource has a `precondition` that requires `var.env == \"production\"`, "
                "but the default value for `var.env` is `\"dev\"`, causing the plan to always fail."
            ),
            "objective": "Fix the precondition so it accepts any valid environment value: dev, staging, or production.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["resource precondition", "lifecycle conditions", "variable validation"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "env" {
  type    = string
  default = "dev"
}

resource "local_file" "config" {
  content  = "env=${var.env}"
  filename = "${path.module}/config.txt"

  # Bug: condition is too strict — only allows "production", rejecting "dev" and "staging"
  lifecycle {
    precondition {
      condition     = var.env == "production"
      error_message = "Environment must be valid."
    }
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "env" {
  type    = string
  default = "dev"
}

resource "local_file" "config" {
  content  = "env=${var.env}"
  filename = "${path.module}/config.txt"

  lifecycle {
    precondition {
      condition     = contains(["dev", "staging", "production"], var.env)
      error_message = "Environment must be one of: dev, staging, production."
    }
  }
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The precondition check fails because `var.env` defaults to `\"dev\"`, which is not equal to `\"production\"`.",
            "The precondition is too restrictive — it only allows `\"production\"`. Valid environments are `dev`, `staging`, and `production`.",
            "Use `contains([\"dev\", \"staging\", \"production\"], var.env)` to accept all valid environments.",
        ],
        "debrief": """\
# Too Strict a Gate

## What Was Broken
`condition = var.env == "production"` rejects all non-production environments, making it
impossible to plan with `var.env = "dev"` (the default).

## The Fix
```hcl
precondition {
  condition     = contains(["dev", "staging", "production"], var.env)
  error_message = "Environment must be one of: dev, staging, production."
}
```

## Precondition Best Practices
- Conditions should validate *validity*, not enforce a specific value unless truly required.
- Use `contains()` for membership checks against an allowlist.
- Pair preconditions with variable `validation` blocks for early feedback.

## Why It Matters
Overly strict preconditions can block legitimate plans. Conditions should reflect your actual
business rules, not incidental constraints.
""",
        "common_mistakes": """\
# Common Mistakes

- **Equality check instead of membership check** — `== "production"` vs `contains([...], var.env)`.
- **Forgetting to update the error message** — the message should describe the valid values.
- **Duplicate validation** — if you have a `variable` validation block already, a precondition may be redundant.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 13 — dynamic-nested-block
# ─────────────────────────────────────────────────────────────────────────────
def _level_13_dynamic_nested_block():
    return {
        "module": MODULE,
        "slug": "level-13-dynamic-nested-block",
        "mission": {
            "name": "Iterator Identity Crisis",
            "description": (
                "A double-nested `dynamic` block uses the default iterator name for both the outer and inner "
                "loops. The inner iterator shadows the outer, making the outer iterator inaccessible inside "
                "the inner block."
            ),
            "objective": "Give the inner `dynamic` block a unique `iterator` name so both levels are accessible.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["nested dynamic blocks", "iterator naming", "dynamic block"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
locals {
  environments = {
    prod = ["us-east-1", "eu-west-1"]
    dev  = ["us-east-1"]
  }
}

# Bug: nested for expressions work fine, but a nested dynamic block pattern
# with identical iterators causes the outer iterator to be inaccessible.
# The correct fix is to use explicit 'iterator' labels on nested dynamic blocks.
#
# Simulated here: the locals below produce wrong output because the inner loop
# incorrectly re-uses the variable name 'env' causing a shadowing bug in complex expressions.

locals {
  # Wrong: tries to use 'env' in both outer and inner scope — inner shadows outer
  bad_pairs = flatten([
    for env in keys(local.environments) : [
      for env in local.environments[env] : "${env}:${env}"
    ]
  ])

  # Correct: rename inner iterator to avoid shadowing
  good_pairs = flatten([
    for env_name in keys(local.environments) : [
      for region in local.environments[env_name] : "${env_name}:${region}"
    ]
  ])
}

resource "local_file" "region_map" {
  content  = join("\\n", local.good_pairs)
  filename = "${path.module}/regions.txt"
}

output "pair_count" {
  value = length(local.good_pairs)
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
locals {
  environments = {
    prod = ["us-east-1", "eu-west-1"]
    dev  = ["us-east-1"]
  }
}

locals {
  good_pairs = flatten([
    for env_name in keys(local.environments) : [
      for region in local.environments[env_name] : "${env_name}:${region}"
    ]
  ])
}

resource "local_file" "region_map" {
  content  = join("\\n", local.good_pairs)
  filename = "${path.module}/regions.txt"
}

output "pair_count" {
  value = length(local.good_pairs)
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "When nesting `dynamic` blocks or `for` expressions, using the same variable name for inner and outer loops causes the inner to shadow the outer.",
            "The inner `for env in ...` reuses `env`, which means inside the inner loop `env` refers to the region, not the environment name.",
            "Rename the outer iterator to `env_name` and the inner to `region` to make both accessible and unambiguous.",
        ],
        "debrief": """\
# Iterator Identity Crisis

## What Was Broken
The inner `for` loop reused the variable name `env`, shadowing the outer `env`. Inside the inner
loop, `env` referred to the region string, not the environment name. This produced pairs like
`us-east-1:us-east-1` instead of `prod:us-east-1`.

## The Fix Pattern
```hcl
# Wrong — shadowing
for env in keys(local.environments) : [
  for env in local.environments[env] : "${env}:${env}"
]

# Correct — unique names
for env_name in keys(local.environments) : [
  for region in local.environments[env_name] : "${env_name}:${region}"
]
```

## Dynamic Block Equivalent
For `dynamic` blocks, use the `iterator` argument to name the iteration variable:
```hcl
dynamic "outer" {
  for_each = var.outer_items
  iterator = outer_item
  content {
    dynamic "inner" {
      for_each = outer_item.value.sub_items
      iterator = inner_item   # unique name prevents shadowing
      content {
        label = "${outer_item.value.name}:${inner_item.value}"
      }
    }
  }
}
```

## Why It Matters
Iterator shadowing is a subtle logic bug — the configuration is syntactically valid but
produces incorrect values at runtime.
""",
        "common_mistakes": """\
# Common Mistakes

- **Reusing iterator names in nested loops** — always use unique names for each nesting level.
- **Omitting `iterator` on nested dynamic blocks** — the default name is the block type, which may collide.
- **Forgetting to update inner references** after renaming the outer iterator.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 14 — check-block
# ─────────────────────────────────────────────────────────────────────────────
def _level_14_check_block():
    return {
        "module": MODULE,
        "slug": "level-14-check-block",
        "mission": {
            "name": "Always Failing Assertion",
            "description": (
                "A `check` block asserts that `local_file.config.id != \"\"`, but the `id` attribute "
                "for `local_file` may not be the meaningful non-empty indicator. "
                "The correct attribute to check is `.filename`."
            ),
            "objective": "Fix the `check` block assertion to use `local_file.config.filename != \"\"`.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["check block", "TF 1.5+", "assertions", "resource attributes"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "check this file"
  filename = "${path.module}/config.txt"
}

# Bug: .id on local_file may be empty or unexpected; use .filename for a meaningful check
check "file_exists" {
  assert {
    condition     = local_file.config.id != ""
    error_message = "Config file was not created properly."
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "check this file"
  filename = "${path.module}/config.txt"
}

check "file_exists" {
  assert {
    condition     = local_file.config.filename != ""
    error_message = "Config file was not created properly."
  }
}
""",
        },
        "validate": validate_tf_apply(),
        "hints": [
            "After apply, the check block assertion fails. Look at what attribute is being checked: `local_file.config.id`.",
            "For `local_file`, the meaningful identifier is `filename` — this is what you should verify is non-empty.",
            "Change `local_file.config.id` to `local_file.config.filename` in the condition.",
        ],
        "debrief": """\
# Always Failing Assertion

## What Was Broken
`local_file.config.id` may not be the right attribute to assert on. The `filename` attribute
is the canonical identifier for a `local_file` resource and will always be non-empty after creation.

## The Fix
```hcl
check "file_exists" {
  assert {
    condition     = local_file.config.filename != ""
    error_message = "Config file was not created properly."
  }
}
```

## check Block (Terraform 1.5+)
- `check` blocks run assertions after apply (non-blocking by default).
- They are ideal for post-deployment health checks.
- Unlike preconditions/postconditions, failed checks produce warnings, not errors.

## Why It Matters
Choosing the right attribute for assertions is critical. Asserting on a wrong attribute
either always passes (never catches real failures) or always fails (creates noise).
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `.id` when `.filename` or another attribute is more appropriate** — check provider docs for attribute semantics.
- **Treating check failures as hard errors** — by default they are warnings.
- **Asserting on computed values that aren't stable** — avoid assertions on values that change each apply.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 15 — ephemeral-pattern
# ─────────────────────────────────────────────────────────────────────────────
def _level_15_ephemeral_pattern():
    return {
        "module": MODULE,
        "slug": "level-15-ephemeral-pattern",
        "mission": {
            "name": "Secrets Leaking into State",
            "description": (
                "A `random_password` is generated and its result is written directly to a `local_file`. "
                "The password is exposed in plain text. "
                "Fix this by using `local_sensitive_file` and marking the output as sensitive."
            ),
            "objective": "Switch to `local_sensitive_file` and add `sensitive = true` to the output.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["ephemeral-like patterns", "sensitive values", "secret management"],
        },
        "broken": {
            "terraform.tf": DEFAULT_TERRAFORM_TF,
            "main.tf": """\
resource "random_password" "db_pass" {
  length  = 16
  special = true
}

# Bug: writing sensitive value to local_file exposes it with world-readable permissions
resource "local_file" "secret" {
  content  = random_password.db_pass.result
  filename = "${path.module}/secret.txt"
}

output "db_password" {
  value = random_password.db_pass.result
  # Missing: sensitive = true
}
""",
        },
        "solution": {
            "terraform.tf": DEFAULT_TERRAFORM_TF,
            "main.tf": """\
resource "random_password" "db_pass" {
  length  = 16
  special = true
}

resource "local_sensitive_file" "secret" {
  content  = random_password.db_pass.result
  filename = "${path.module}/secret.txt"
}

output "db_password" {
  value     = random_password.db_pass.result
  sensitive = true
}
""",
        },
        "validate": validate_tf_apply(),
        "hints": [
            "The `local_file` resource writes content with default permissions (world-readable). For sensitive data, use `local_sensitive_file` which sets mode 0600.",
            "The `output` block exposes the password in plain text in terminal output. Add `sensitive = true` to hide it.",
            "Replace `local_file` with `local_sensitive_file` and add `sensitive = true` to the output block.",
        ],
        "debrief": """\
# Secrets Leaking into State

## What Was Broken
1. `local_file` writes with world-readable permissions and no sensitivity marking.
2. The `output` block exposes the password in plain text in terminal output.

## The Fix
```hcl
resource "local_sensitive_file" "secret" {
  content  = random_password.db_pass.result
  filename = "${path.module}/secret.txt"
}

output "db_password" {
  value     = random_password.db_pass.result
  sensitive = true
}
```

## Sensitive Value Best Practices
- Use `local_sensitive_file` for files containing secrets (sets mode 0600).
- Mark outputs `sensitive = true` to prevent plain-text display.
- Note: Terraform state still contains the value — use remote state with encryption.
- For true ephemeral secrets, use Vault or cloud-native secret managers.

## Why It Matters
Secrets written to plain-text files or displayed in output can be captured in logs, CI pipelines,
and shared terminals. Defense in depth requires sensitivity marking at every layer.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `local_file` for secrets** — it writes world-readable files.
- **Forgetting `sensitive = true` on outputs** — the value appears in `terraform output` and apply logs.
- **Thinking state encryption is automatic** — it requires backend configuration.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 16 — lifecycle-ignore-all
# ─────────────────────────────────────────────────────────────────────────────
def _level_16_lifecycle_ignore_all():
    return {
        "module": MODULE,
        "slug": "level-16-lifecycle-ignore-all",
        "mission": {
            "name": "Ignoring Everything (Including Security)",
            "description": (
                "A resource uses `ignore_changes = all`, which causes Terraform to ignore ALL attribute "
                "changes — including security-critical ones like `file_permission`. "
                "Fix this by using a specific attribute list."
            ),
            "objective": "Replace `ignore_changes = all` with a specific list that only ignores `content`.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["ignore_changes = all vs specific", "lifecycle", "security"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "app_config" {
  content         = "app_version=1.0.0"
  filename        = "${path.module}/app.cfg"
  file_permission = "0600"

  # Bug: ignore_changes = all prevents ANY drift from being detected,
  # including critical changes to file_permission
  lifecycle {
    ignore_changes = all
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "app_config" {
  content         = "app_version=1.0.0"
  filename        = "${path.module}/app.cfg"
  file_permission = "0600"

  lifecycle {
    ignore_changes = [content]
  }
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The config is syntactically valid, but `ignore_changes = all` means Terraform will never detect drift on ANY attribute, including `file_permission`.",
            "`ignore_changes = all` is only appropriate for fully externally-managed resources. Here, we still want to detect permission changes.",
            "Replace `ignore_changes = all` with `ignore_changes = [content]` to only ignore content drift while monitoring other attributes.",
        ],
        "debrief": """\
# Ignoring Everything (Including Security)

## What Was Broken
`ignore_changes = all` instructs Terraform to never update the resource regardless of what changes.
A permission change from `0600` to `0777` would go undetected and uncorrected.

## The Fix
```hcl
lifecycle {
  ignore_changes = [content]
}
```

## ignore_changes Best Practices
| Use case | Recommendation |
|---|---|
| Externally updated content (e.g., app writes to file) | `ignore_changes = [content]` |
| Fully externally managed resource | `ignore_changes = all` (use sparingly) |
| Security-critical attributes | Never ignore |

## Why It Matters
`ignore_changes = all` is a blunt instrument that should be used only when Terraform should
never manage updates to a resource. Security-critical attributes like permissions, encryption
settings, and access controls should always be monitored.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `ignore_changes = all` as a quick fix for perpetual diffs** — find the root cause instead.
- **Not listing all attributes that need ignoring** — partial lists miss externally-managed fields.
- **Forgetting that `ignore_changes` doesn't prevent drift detection in plan** — it prevents Terraform from *fixing* drift, not from *reporting* it.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 17 — custom-condition
# ─────────────────────────────────────────────────────────────────────────────
def _level_17_custom_condition():
    return {
        "module": MODULE,
        "slug": "level-17-custom-condition",
        "mission": {
            "name": "Backwards Logic",
            "description": (
                "A precondition is meant to ensure `var.min_size` is less than `var.max_size`, "
                "but the condition is written with `>` instead of `<`, inverting the logic."
            ),
            "objective": "Fix the precondition so it correctly validates that `min_size < max_size`.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["precondition logic", "custom conditions", "variable validation"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 10
}

resource "local_file" "config" {
  content  = "min=${var.min_size} max=${var.max_size}"
  filename = "${path.module}/size_config.txt"

  # Bug: condition is inverted — uses > instead of <
  # This passes when min > max (invalid) and fails when min < max (valid)
  lifecycle {
    precondition {
      condition     = var.min_size > var.max_size
      error_message = "min_size must be less than max_size."
    }
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 10
}

resource "local_file" "config" {
  content  = "min=${var.min_size} max=${var.max_size}"
  filename = "${path.module}/size_config.txt"

  lifecycle {
    precondition {
      condition     = var.min_size < var.max_size
      error_message = "min_size must be less than max_size."
    }
  }
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan` with the defaults (`min_size=1`, `max_size=10`). The precondition fails even though 1 < 10 is valid.",
            "Read the condition carefully: `var.min_size > var.max_size` is TRUE when min is GREATER than max — which is the invalid case. The condition should be TRUE for valid input.",
            "Change `>` to `<`: `condition = var.min_size < var.max_size`.",
        ],
        "debrief": """\
# Backwards Logic

## What Was Broken
`condition = var.min_size > var.max_size` evaluates to `true` when `min_size > max_size`,
which is the *invalid* case. Terraform's `precondition` passes when `condition = true`,
so this passes on invalid input and fails on valid input.

## The Fix
```hcl
precondition {
  condition     = var.min_size < var.max_size
  error_message = "min_size must be less than max_size."
}
```

## Condition Semantics
- `condition = true` → constraint satisfied → proceed
- `condition = false` → constraint violated → fail with `error_message`

## Why It Matters
Inverted logic in preconditions blocks legitimate plans while allowing invalid configurations
through. This is especially dangerous in security or sizing constraints.
""",
        "common_mistakes": """\
# Common Mistakes

- **Inverting the comparison operator** — `>` vs `<`, or `==` vs `!=`.
- **Writing the error_message from the false branch perspective** — the message should describe the *required* condition, not the failure mode.
- **Forgetting `!` for negation** — use `!condition` to invert a complex boolean expression.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 18 — provider-version-lock
# ─────────────────────────────────────────────────────────────────────────────
def _level_18_provider_version_lock():
    _broken_lock = """\
# This file is maintained automatically by "terraform init".
# Manual edits may be lost in future updates.

provider "registry.terraform.io/hashicorp/local" {
  version     = "2.5.1"
  constraints = "~> 2.5"
  hashes = [
    "h1:INVALIDHASHVALUE123456789abcdef0000000000000=",
    "zh:INVALIDZHASHVALUE123456789abcdef0000000000000000000000000000000=",
  ]
}
"""
    return {
        "module": MODULE,
        "slug": "level-18-provider-version-lock",
        "mission": {
            "name": "Corrupted Lock File",
            "description": (
                "The `.terraform.lock.hcl` file contains an invalid provider hash, "
                "causing `terraform init` to fail with a hash mismatch error."
            ),
            "objective": "Delete the corrupted lock file so `terraform init -upgrade` can regenerate it correctly.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["lock file management", "provider hashes", "terraform init"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "lock file test"
  filename = "${path.module}/config.txt"
}
""",
            ".terraform.lock.hcl": _broken_lock,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "lock file test"
  filename = "${path.module}/config.txt"
}
""",
            # No .terraform.lock.hcl — it is deleted and regenerated by init
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# Remove corrupted lock file if present
rm -f .terraform.lock.hcl

if terraform init -upgrade -no-color 2>&1; then
    echo "PASS: terraform init succeeded after removing corrupted lock file"
    exit 0
fi
echo "FAIL: terraform init failed even after removing lock file"
exit 1
"""),
        "hints": [
            "Run `terraform init`. The error mentions a hash mismatch for the `local` provider. The lock file contains invalid hashes.",
            "The `.terraform.lock.hcl` file in the `broken/` directory has fake hashes. Terraform cannot proceed because the downloaded provider doesn't match.",
            "Delete `.terraform.lock.hcl` and run `terraform init -upgrade`. Terraform regenerates the lock file with correct hashes from the registry.",
        ],
        "debrief": """\
# Corrupted Lock File

## What Was Broken
`.terraform.lock.hcl` contained invalid hashes for the `hashicorp/local` provider.
Terraform verifies provider hashes against the lock file to ensure integrity —
an invalid hash causes `init` to abort.

## The Fix
```bash
rm -f .terraform.lock.hcl
terraform init -upgrade
```
Terraform regenerates the lock file with correct hashes from the registry.

## Lock File Purpose
- Pins exact provider versions and their cryptographic hashes
- Ensures all team members use identical provider binaries
- Should be committed to version control

## When to Delete the Lock File
- When hashes are corrupted or manually edited incorrectly
- When upgrading to a new platform/architecture
- Never delete it casually — it protects supply chain integrity

## Why It Matters
The lock file is a security control. Tampering with it (accidentally or maliciously) can
allow different provider binaries to be used than intended.
""",
        "common_mistakes": """\
# Common Mistakes

- **Manually editing the lock file** — always let `terraform init` manage it.
- **Committing a platform-specific lock file** — use `terraform providers lock` to add multiple platform hashes.
- **Ignoring hash mismatch errors** — they indicate either corruption or a supply chain issue.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 19 — complex-refactor
# ─────────────────────────────────────────────────────────────────────────────
def _level_19_complex_refactor():
    return {
        "module": MODULE,
        "slug": "level-19-complex-refactor",
        "mission": {
            "name": "The Great Migration",
            "description": (
                "Three resources are being migrated from `count` to `for_each`. "
                "Multiple `moved` blocks are present but all use incorrect instance key formats — "
                "unquoted identifiers instead of quoted string keys."
            ),
            "objective": "Fix all three `moved` blocks to use correct for_each string key format.",
            "xp": 400,
            "difficulty": "expert",
            "expected_time": "30m",
            "concepts": ["complex refactoring", "count to for_each migration", "moved blocks", "instance keys"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# These resources have been migrated from count to for_each.
# The moved blocks below are incorrect — they use unquoted identifiers as the 'to' keys
# instead of quoted string keys.

resource "local_file" "service" {
  for_each = toset(["web", "api", "worker"])
  content  = "service: ${each.key}"
  filename = "${path.module}/service-${each.key}.txt"
}

# Bug: 'to' keys should be quoted strings like ["web"], ["api"], ["worker"]
moved {
  from = local_file.service[0]
  to   = local_file.service[web]
}

moved {
  from = local_file.service[1]
  to   = local_file.service[api]
}

moved {
  from = local_file.service[2]
  to   = local_file.service[worker]
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "service" {
  for_each = toset(["web", "api", "worker"])
  content  = "service: ${each.key}"
  filename = "${path.module}/service-${each.key}.txt"
}

moved {
  from = local_file.service[0]
  to   = local_file.service["web"]
}

moved {
  from = local_file.service[1]
  to   = local_file.service["api"]
}

moved {
  from = local_file.service[2]
  to   = local_file.service["worker"]
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform validate`. All three `moved` blocks have errors on the `to` lines. Each unquoted identifier like `[web]` is invalid HCL.",
            "For `for_each` resources with string keys, instance addresses use quoted strings: `resource_type.label[\"key\"]`. The numeric `from` addresses are correct for the old count-based state.",
            "Fix all three `to` addresses: `local_file.service[\"web\"]`, `local_file.service[\"api\"]`, `local_file.service[\"worker\"]`.",
        ],
        "debrief": """\
# The Great Migration

## What Was Broken
All three `moved` blocks used unquoted identifiers as for_each keys:
- `local_file.service[web]` should be `local_file.service["web"]`
- `local_file.service[api]` should be `local_file.service["api"]`
- `local_file.service[worker]` should be `local_file.service["worker"]`

## The Fix
```hcl
moved {
  from = local_file.service[0]
  to   = local_file.service["web"]
}
moved {
  from = local_file.service[1]
  to   = local_file.service["api"]
}
moved {
  from = local_file.service[2]
  to   = local_file.service["worker"]
}
```

## count-to-for_each Migration Pattern
1. Keep existing count-based state (old instances at `[0]`, `[1]`, etc.)
2. Change resource to use `for_each` with a set/map
3. Add `moved` blocks for each instance: `from = resource[N]`, `to = resource["key"]`
4. Run `terraform plan` — should show 0 destroys, 0 creates

## Why It Matters
A failed count-to-for_each migration causes Terraform to destroy all count-indexed instances
and recreate them as for_each instances — potentially destroying production infrastructure.
""",
        "common_mistakes": """\
# Common Mistakes

- **Unquoted string keys in `to` addresses** — always quote for_each string keys.
- **Wrong key order** — ensure count index N maps to the correct string key.
- **Forgetting a moved block for one instance** — all instances need a `moved` block.
- **Running apply before plan** — always verify the plan shows no unexpected destroys.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 20 — identity-token
# ─────────────────────────────────────────────────────────────────────────────
def _level_20_identity_token():
    return {
        "module": MODULE,
        "slug": "level-20-identity-token",
        "mission": {
            "name": "Token Validation Trap",
            "description": (
                "An auth token variable has a `validation` block with an overly strict regex that "
                "rejects valid token formats. The regex only allows lowercase hex, but real tokens "
                "contain uppercase letters and hyphens."
            ),
            "objective": "Fix the variable validation regex to accept alphanumeric characters and hyphens, 32-128 characters long.",
            "xp": 325,
            "difficulty": "advanced",
            "expected_time": "25m",
            "concepts": ["auth patterns", "variable validation", "regex in Terraform"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Simulates an auth token configuration pattern.
# The token variable has a broken validation regex that rejects valid tokens.

variable "auth_token" {
  type        = string
  description = "Authentication token for the service."
  default     = "MyService-Token-ABC123-xyz789-ABCDEF"

  validation {
    # Bug: regex only allows lowercase hex [0-9a-f], rejecting uppercase and hyphens
    condition     = can(regex("^[0-9a-f]{32,128}$", var.auth_token))
    error_message = "auth_token must be a valid token (alphanumeric and hyphens, 32-128 chars)."
  }
}

resource "local_file" "auth_config" {
  content         = "token=${var.auth_token}"
  filename        = "${path.module}/auth.cfg"
  file_permission = "0600"
}

output "token_length" {
  value = length(var.auth_token)
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "auth_token" {
  type        = string
  description = "Authentication token for the service."
  default     = "MyService-Token-ABC123-xyz789-ABCDEF"

  validation {
    condition     = can(regex("^[A-Za-z0-9-]{32,128}$", var.auth_token))
    error_message = "auth_token must be a valid token (alphanumeric and hyphens, 32-128 chars)."
  }
}

resource "local_file" "auth_config" {
  content         = "token=${var.auth_token}"
  filename        = "${path.module}/auth.cfg"
  file_permission = "0600"
}

output "token_length" {
  value = length(var.auth_token)
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The validation block rejects the default token value. Look at the regex pattern: `^[0-9a-f]{32,128}$`.",
            "The regex `[0-9a-f]` only matches lowercase hexadecimal characters. The default token contains uppercase letters and hyphens.",
            "Change the regex to `^[A-Za-z0-9-]{32,128}$` to allow uppercase letters, lowercase letters, digits, and hyphens.",
        ],
        "debrief": """\
# Token Validation Trap

## What Was Broken
The regex `^[0-9a-f]{32,128}$` only accepts lowercase hexadecimal strings.
A real-world auth token `MyService-Token-ABC123-xyz789-ABCDEF` contains uppercase letters
and hyphens, which are rejected.

## The Fix
```hcl
validation {
  condition     = can(regex("^[A-Za-z0-9-]{32,128}$", var.auth_token))
  error_message = "auth_token must be a valid token (alphanumeric and hyphens, 32-128 chars)."
}
```

## Regex in Terraform Validations
- `can(regex(...))` returns `true` if the regex matches, `false` otherwise.
- Always test your regex against representative values including edge cases.
- Use online regex testers to verify patterns before committing.

## Auth Pattern Best Practices
- Store tokens in secure backends (Vault, AWS Secrets Manager) — not in variables with defaults.
- Use `sensitive = true` on token variables.
- Mark the resource as `local_sensitive_file` if writing tokens to disk.

## Why It Matters
Overly restrictive validation blocks legitimate configurations. Overly permissive validation
allows invalid values through. Strike the right balance by understanding the actual token format.
""",
        "common_mistakes": """\
# Common Mistakes

- **Overly restrictive character classes** — `[0-9a-f]` (hex only) vs `[A-Za-z0-9-]` (alphanumeric + hyphen).
- **Forgetting `can()` wrapper** — `regex()` throws an error if the pattern doesn't match; `can()` converts it to false.
- **Not testing with the actual default value** — always run `terraform validate` after writing a validation block.
""",
    }


if __name__ == "__main__":
    build()
