#!/usr/bin/env python3
"""Module 7 — Loops & Conditionals (18 levels, Intermediate)."""
from __future__ import annotations

import textwrap

from scripts.build_utils import (
    DEFAULT_TERRAFORM_TF,
    LOCAL_ONLY_TF,
    print_done,
    validate_tf_plan,
    validate_tf_validate,
    write_level,
)

MODULE = "module-7-loops"


def build() -> int:
    levels = [
        _level_01_count_basics(),
        _level_02_count_zero(),
        _level_03_count_index_off_by_one(),
        _level_04_count_conditional(),
        _level_05_count_output_splat(),
        _level_06_for_each_set(),
        _level_07_for_each_map(),
        _level_08_for_each_output(),
        _level_09_for_each_dependency(),
        _level_10_for_each_empty(),
        _level_11_for_each_count_mix(),
        _level_12_dynamic_block_basics(),
        _level_13_dynamic_content(),
        _level_14_dynamic_optional(),
        _level_15_nested_for_each_flatten(),
        _level_16_for_each_known_after_apply(),
        _level_17_count_to_for_each_migration(),
        _level_18_conditional_module_call(),
    ]
    for lvl in levels:
        write_level(lvl)
    print_done(MODULE, len(levels))
    return len(levels)


# ── validate helpers ──────────────────────────────────────────────────────────

def _validate_plan_no_destroy() -> str:
    return textwrap.dedent("""\
        #!/usr/bin/env bash
        set -euo pipefail

        terraform init -no-color -input=false 2>&1

        OUTPUT=$(terraform plan -detailed-exitcode -no-color -input=false 2>&1)
        CODE=$?
        echo "$OUTPUT"
        if [[ $CODE -eq 1 ]]; then
            echo "❌ FAIL: terraform plan returned error"
            exit 1
        fi
        if echo "$OUTPUT" | grep -q "will be destroyed"; then
            echo "❌ FAIL: plan shows resource destruction — moved block may be missing"
            exit 1
        fi
        echo "✅ PASS: plan completed without destruction"
        exit 0
    """)


# ─────────────────────────────────────────────────────────────────────────────
# Level 1 — count-basics
# ─────────────────────────────────────────────────────────────────────────────
def _level_01_count_basics():
    return {
        "module": MODULE,
        "slug": "level-1-count-basics",
        "mission": {
            "name": "Three Files, Same Name",
            "description": (
                "`count = 3` creates three instances of a `local_file` resource, "
                "but all three use the same `filename = \"config.txt\"` — no `count.index` is used. "
                "The three instances would all write to the same file."
            ),
            "objective": "Use `count.index` in the `filename` so each instance gets a unique filename like `config-0.txt`, `config-1.txt`, `config-2.txt`.",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "8m",
            "concepts": ["count", "count.index", "unique filenames"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# All three instances share the same filename — only one file would survive.
resource "local_file" "config" {
  count    = 3
  content  = "config instance"
  filename = "${path.module}/config.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  count    = 3
  content  = "config instance ${count.index}"
  filename = "${path.module}/config-${count.index}.txt"
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. All three instances produce the same `filename` value, which is a problem.",
            "`count.index` gives the current instance number (0, 1, 2). Use it to make each filename unique.",
            "Change `filename` to `\"${path.module}/config-${count.index}.txt\"`.",
        ],
        "debrief": """\
# Three Files, Same Name

## What Was Broken
`filename = "${path.module}/config.txt"` is the same for all three `count` instances.
Each resource instance needs a unique address — and in this case, a unique file path.

## Using count.index
```hcl
resource "local_file" "config" {
  count    = 3
  content  = "config instance ${count.index}"
  filename = "${path.module}/config-${count.index}.txt"
}
# Creates: config-0.txt, config-1.txt, config-2.txt
```

## Addressing Counted Resources
```hcl
local_file.config[0].filename   # "config-0.txt"
local_file.config[1].filename   # "config-1.txt"
local_file.config[*].filename   # all three via splat
```

## Concepts
- `count.index` — zero-based index available in `count`-based resources
- Every resource instance must have a unique set of argument values that produce unique identifiers
""",
        "common_mistakes": """\
# Common Mistakes

- **Forgetting count.index** — always use `count.index` to differentiate counted resource instances.
- **One-based thinking** — `count.index` is 0, 1, 2, not 1, 2, 3.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 2 — count-zero
# ─────────────────────────────────────────────────────────────────────────────
def _level_02_count_zero():
    return {
        "module": MODULE,
        "slug": "level-2-count-zero",
        "mission": {
            "name": "Referencing a Zero-Count Resource",
            "description": (
                "`count = var.enabled ? 1 : 0` conditionally creates a resource. "
                "With `enabled = false`, `count = 0` and no instance exists. "
                "The output references `local_file.config[0].filename` — which errors when count is 0."
            ),
            "objective": "Fix the output to use `try(local_file.config[0].filename, \"\")` so it safely handles the count=0 case.",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "8m",
            "concepts": ["count=0", "conditional resources", "try()", "safe output access"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "enabled" {
  type    = bool
  default = false
}

resource "local_file" "config" {
  count    = var.enabled ? 1 : 0
  content  = "config"
  filename = "${path.module}/config.txt"
}

# This will error when count = 0 (enabled = false)
output "config_path" {
  value = local_file.config[0].filename
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "enabled" {
  type    = bool
  default = false
}

resource "local_file" "config" {
  count    = var.enabled ? 1 : 0
  content  = "config"
  filename = "${path.module}/config.txt"
}

output "config_path" {
  value = try(local_file.config[0].filename, "")
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. With `enabled = false`, `count = 0` — there is no `local_file.config[0]`.",
            "Use the `try()` function to return a fallback value when the reference fails.",
            "Change the output to `value = try(local_file.config[0].filename, \"\")`.",
        ],
        "debrief": """\
# Referencing a Zero-Count Resource

## What Was Broken
`local_file.config[0].filename` errors when `count = 0` because instance `[0]` doesn't exist.

## The try() Function
`try(expression, fallback)` returns `expression` if it succeeds, or `fallback` if it errors:

```hcl
output "config_path" {
  value = try(local_file.config[0].filename, "")
}
```

## Alternative: Use one() or check count
```hcl
output "config_path" {
  value = length(local_file.config) > 0 ? local_file.config[0].filename : ""
}
```

Or use `one()` which returns null for empty collections:
```hcl
output "config_path" {
  value = one(local_file.config[*].filename)
}
```

## Concepts
- `count = 0` is a valid way to conditionally create/destroy a resource
- Always guard outputs that reference conditional resources
""",
        "common_mistakes": """\
# Common Mistakes

- **Hardcoding `[0]` without guarding** — always check or use `try()` when count might be 0.
- **Using `count = 0` to delete resources** — this works, but is sometimes surprising when outputs break.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 3 — count-index-off-by-one
# ─────────────────────────────────────────────────────────────────────────────
def _level_03_count_index_off_by_one():
    return {
        "module": MODULE,
        "slug": "level-3-count-index-off-by-one",
        "mission": {
            "name": "Off-by-One Output",
            "description": (
                "Three files are created: `file-0.txt`, `file-1.txt`, `file-2.txt`. "
                "The output expects files named `file-1.txt` through `file-3.txt` — "
                "an off-by-one in the output expression."
            ),
            "objective": "Fix the output to correctly reference `file-0.txt` through `file-2.txt` using `local_file.files[*].filename`.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["count.index offset", "splat expression", "output values"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "files" {
  count    = 3
  content  = "file content ${count.index}"
  filename = "${path.module}/file-${count.index}.txt"
}

# Wrong: tries to reference files 1-3 instead of 0-2.
output "file_names" {
  value = [
    local_file.files[1].filename,
    local_file.files[2].filename,
    local_file.files[3].filename,
  ]
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "files" {
  count    = 3
  content  = "file content ${count.index}"
  filename = "${path.module}/file-${count.index}.txt"
}

output "file_names" {
  value = local_file.files[*].filename
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. It says index `[3]` is out of range — there are only instances 0, 1, 2.",
            "`count = 3` creates instances at indices 0, 1, 2 (not 1, 2, 3).",
            "Use the splat expression `local_file.files[*].filename` to get all filenames without hardcoding indices.",
        ],
        "debrief": """\
# Off-by-One Output

## What Was Broken
`count = 3` creates indices 0, 1, 2. Referencing `[3]` is out of bounds.

## The Splat Expression
Instead of listing individual indices, use the splat operator `[*]`:
```hcl
output "file_names" {
  value = local_file.files[*].filename
  # Returns: ["file-0.txt", "file-1.txt", "file-2.txt"]
}
```

## Valid Indices for count = 3
- `[0]` — first instance
- `[1]` — second instance
- `[2]` — third instance
- `[3]` — out of bounds (error)

## Concepts
- `count` indices are always 0-based
- The splat `[*]` operator is the safest way to reference all count instances
""",
        "common_mistakes": """\
# Common Mistakes

- **One-based indices** — `count = 3` gives indices 0, 1, 2 — never 1, 2, 3.
- **Hardcoding indices** — prefer `[*]` splat over listing `[0]`, `[1]`, `[2]` individually.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 4 — count-conditional
# ─────────────────────────────────────────────────────────────────────────────
def _level_04_count_conditional():
    return {
        "module": MODULE,
        "slug": "level-4-count-conditional",
        "mission": {
            "name": "String Bool in Conditional Count",
            "description": (
                "`count = var.enabled ? 1 : 0` requires `var.enabled` to be a `bool`. "
                "The variable is declared as `type = string` with `default = \"true\"`. "
                "Terraform cannot use a string in the ternary condition."
            ),
            "objective": "Change `var.enabled` to `type = bool` with `default = true` so the conditional works correctly.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["ternary with count", "bool type", "type system"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "enabled" {
  type    = string
  default = "true"
}

# String can't be used directly in a ternary condition as a bool
resource "local_file" "config" {
  count    = var.enabled ? 1 : 0
  content  = "enabled config"
  filename = "${path.module}/config.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "enabled" {
  type    = bool
  default = true
}

resource "local_file" "config" {
  count    = var.enabled ? 1 : 0
  content  = "enabled config"
  filename = "${path.module}/config.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says a bool is expected but a string was provided.",
            "`var.enabled` is `type = string` — strings are not booleans in HCL.",
            "Change `type = string` to `type = bool` and `default = \"true\"` to `default = true`.",
        ],
        "debrief": """\
# String Bool in Conditional Count

## What Was Broken
`var.enabled ? 1 : 0` requires `var.enabled` to evaluate as a boolean.
`type = string` with `default = "true"` provides a string, which Terraform cannot
implicitly convert to bool in a ternary expression.

## The Fix
```hcl
variable "enabled" {
  type    = bool      # not string
  default = true      # not "true"
}
```

## HCL Boolean Literals
```hcl
default = true    # bool
default = false   # bool
default = "true"  # string (not a bool!)
```

## Concepts
- `bool` and `string` are distinct types in Terraform's type system
- Ternary `condition ? true_val : false_val` requires condition to be a bool
""",
        "common_mistakes": """\
# Common Mistakes

- **`"true"` vs `true`** — the quoted form is a string; the unquoted form is a boolean.
- **Relying on implicit conversion** — Terraform may sometimes coerce, but explicit types are safer and clearer.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 5 — count-output-splat
# ─────────────────────────────────────────────────────────────────────────────
def _level_05_count_output_splat():
    return {
        "module": MODULE,
        "slug": "level-5-count-output-splat",
        "mission": {
            "name": "Missing Splat on Count Resource",
            "description": (
                "`local_file.config` is a `count`-based resource. "
                "The output references `local_file.config.filename` as if it were a single resource — "
                "but you need `[*]` to get all filenames."
            ),
            "objective": "Fix the output to `value = local_file.config[*].filename`.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["splat expression", "count", "output values"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  count    = 3
  content  = "config ${count.index}"
  filename = "${path.module}/config-${count.index}.txt"
}

# Wrong: count resource can't be referenced without [*] or [N]
output "all_filenames" {
  value = local_file.config.filename
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  count    = 3
  content  = "config ${count.index}"
  filename = "${path.module}/config-${count.index}.txt"
}

output "all_filenames" {
  value = local_file.config[*].filename
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says you must use `[*]` or `[N]` with a count resource.",
            "`local_file.config` has multiple instances; you need to specify which one(s) you want.",
            "Use `local_file.config[*].filename` to get a list of all filenames.",
        ],
        "debrief": """\
# Missing Splat on Count Resource

## What Was Broken
`local_file.config.filename` is not valid when `count > 1`. Terraform doesn't know
whether you want a specific instance or all of them.

## The Splat Operator [*]
```hcl
output "all_filenames" {
  value = local_file.config[*].filename
  # Returns a list: ["config-0.txt", "config-1.txt", "config-2.txt"]
}
```

## Specific Instance
```hcl
output "first_filename" {
  value = local_file.config[0].filename
}
```

## Concepts
- `[*]` splat — returns a list of the attribute across all instances
- Without `[N]` or `[*]`, referencing a count resource is a validation error
""",
        "common_mistakes": """\
# Common Mistakes

- **Omitting `[*]`** — a count resource is a collection, not a single object.
- **Using `[*]` on a non-count resource** — this always returns a list with 0 or 1 elements, which is usually not what you want.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 6 — for-each-set
# ─────────────────────────────────────────────────────────────────────────────
def _level_06_for_each_set():
    return {
        "module": MODULE,
        "slug": "level-6-for-each-set",
        "mission": {
            "name": "Duplicate in toset()",
            "description": (
                "`for_each = toset(var.names)` with `var.names = [\"a\", \"b\", \"a\"]` "
                "works fine because `toset()` deduplicates. However, the variable default "
                "is set to a list with a duplicate `\"a\"`. The config works but produces "
                "only 2 instances instead of the expected 3. "
                "The real bug: the variable default should not have duplicates."
            ),
            "objective": "Remove the duplicate `\"a\"` from `var.names` default so the intent is clear and the set has exactly 2 unique values.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["for_each", "toset", "set deduplication"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "names" {
  type    = list(string)
  # Duplicate 'a' — toset() will silently deduplicate, resulting in only 2 files
  default = ["a", "b", "a"]
}

resource "local_file" "items" {
  for_each = toset(var.names)
  content  = "item: ${each.key}"
  filename = "${path.module}/item-${each.key}.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "names" {
  type    = list(string)
  default = ["a", "b"]
}

resource "local_file" "items" {
  for_each = toset(var.names)
  content  = "item: ${each.key}"
  filename = "${path.module}/item-${each.key}.txt"
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. Only 2 files are created even though 3 names are in the list.",
            "`toset()` deduplicates — `[\"a\", \"b\", \"a\"]` becomes `{\"a\", \"b\"}` (2 elements).",
            "Remove the duplicate `\"a\"` from the `default` list.",
        ],
        "debrief": """\
# Duplicate in toset()

## What Was Broken
`toset([\"a\", \"b\", \"a\"])` silently produces `{\"a\", \"b\"}` — the duplicate is dropped.
If you expect 3 files, you'll only get 2.

## How toset() Works
```hcl
toset(["a", "b", "a"])   # returns: {"a", "b"}  — deduplicated
toset(["a", "b", "c"])   # returns: {"a", "b", "c"}  — all unique
```

## Why It Matters
When building for_each maps from user-provided lists, silent deduplication can cause
fewer resources than expected. Always validate list inputs or use `type = set(string)`.

## Better Variable Type
```hcl
variable "names" {
  type = set(string)   # enforces uniqueness at input time
  default = ["a", "b"]
}
```

## Concepts
- `toset()` deduplicates; there is no error for duplicate values.
- `set(string)` as a variable type prevents duplicates from being passed at all.
""",
        "common_mistakes": """\
# Common Mistakes

- **Expecting 3 files from 3 names with a duplicate** — sets eliminate duplicates silently.
- **Using `list(string)` when you need unique values** — prefer `set(string)` for uniqueness guarantees.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 7 — for-each-map
# ─────────────────────────────────────────────────────────────────────────────
def _level_07_for_each_map():
    return {
        "module": MODULE,
        "slug": "level-7-for-each-map",
        "mission": {
            "name": "each.name vs each.key",
            "description": (
                "`for_each = var.services` iterates over a map. "
                "Inside the resource, `each.name` is used — but `each.name` doesn't exist. "
                "The correct attribute is `each.key`."
            ),
            "objective": "Replace `each.name` with `each.key` so `terraform validate` passes.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["for_each map", "each.key", "each.value"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "services" {
  type = map(string)
  default = {
    web = "nginx"
    db  = "postgres"
  }
}

resource "local_file" "service_config" {
  for_each = var.services
  # Wrong: each.name doesn't exist — use each.key
  content  = "service: ${each.name} = ${each.value}"
  filename = "${path.module}/service-${each.name}.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "services" {
  type = map(string)
  default = {
    web = "nginx"
    db  = "postgres"
  }
}

resource "local_file" "service_config" {
  for_each = var.services
  content  = "service: ${each.key} = ${each.value}"
  filename = "${path.module}/service-${each.key}.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. `each.name` is not a valid attribute.",
            "When iterating a map with `for_each`, use `each.key` for the map key and `each.value` for the map value.",
            "Replace all occurrences of `each.name` with `each.key`.",
        ],
        "debrief": """\
# each.name vs each.key

## What Was Broken
`each.name` is not a valid attribute. The correct attributes are `each.key` and `each.value`.

## each Object Attributes
| Attribute | Value |
|----------|-------|
| `each.key` | The map key (or set element) for the current iteration |
| `each.value` | The map value for the current iteration |

## Example
```hcl
for_each = { web = "nginx", db = "postgres" }

# In each iteration:
each.key   = "web"     (then "db")
each.value = "nginx"   (then "postgres")
```

## Concepts
- `each.key` and `each.value` are the only two attributes of the `each` object
- For `toset()`, `each.key == each.value` (sets don't have separate key/value)
""",
        "common_mistakes": """\
# Common Mistakes

- **`each.name`** — does not exist; always use `each.key` or `each.value`.
- **`each.key` vs `each.value` confusion** — for maps, key is the left side, value is the right side.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 8 — for-each-output
# ─────────────────────────────────────────────────────────────────────────────
def _level_08_for_each_output():
    return {
        "module": MODULE,
        "slug": "level-8-for-each-output",
        "mission": {
            "name": "Wrong Attribute in for Expression",
            "description": (
                "A `for` expression iterates over `local_file.configs` and accesses `.path` — "
                "but the `local_file` resource attribute is `.filename`, not `.path`."
            ),
            "objective": "Fix the for expression to use `.filename` instead of `.path`.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["for expression", "resource attributes", "output values"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "envs" {
  type    = set(string)
  default = ["dev", "prod"]
}

resource "local_file" "configs" {
  for_each = var.envs
  content  = "env=${each.key}"
  filename = "${path.module}/config-${each.key}.txt"
}

# Wrong: local_file has no attribute '.path' — use '.filename'
output "config_paths" {
  value = { for k, v in local_file.configs : k => v.path }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "envs" {
  type    = set(string)
  default = ["dev", "prod"]
}

resource "local_file" "configs" {
  for_each = var.envs
  content  = "env=${each.key}"
  filename = "${path.module}/config-${each.key}.txt"
}

output "config_paths" {
  value = { for k, v in local_file.configs : k => v.filename }
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The `local_file` resource has no attribute named `path`.",
            "Check the `local_file` resource schema — the file path attribute is called `filename`.",
            "Change `v.path` to `v.filename` in the for expression.",
        ],
        "debrief": """\
# Wrong Attribute in for Expression

## What Was Broken
`v.path` does not exist on `local_file` resources. The correct attribute is `v.filename`.

## local_file Key Attributes
```hcl
resource "local_file" "example" {
  content  = "..."
  filename = "/path/to/file.txt"
}
# Attributes: .filename, .content, .id, etc. — no .path
```

## for Expression Syntax
```hcl
{ for k, v in local_file.configs : k => v.filename }
# Returns: { "dev" = "config-dev.txt", "prod" = "config-prod.txt" }
```

## Concepts
- Resource attribute names are defined by the provider schema
- Use `terraform providers schema -json` to inspect available attributes
""",
        "common_mistakes": """\
# Common Mistakes

- **Guessing attribute names** — always check the provider documentation or use `terraform console`.
- **`.path` vs `.filename`** — the local_file provider uses `filename` consistently.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 9 — for-each-dependency
# ─────────────────────────────────────────────────────────────────────────────
def _level_09_for_each_dependency():
    return {
        "module": MODULE,
        "slug": "level-9-for-each-dependency",
        "mission": {
            "name": "Resource as for_each Value",
            "description": (
                "Resource B tries `for_each = local_file.configs` — passing a resource collection directly. "
                "Terraform requires `for_each` to be a map or set, not a resource collection object. "
                "Fix it by converting the resource to a proper map with a `for` expression."
            ),
            "objective": "Change `for_each` to `{ for k, v in local_file.configs : k => v.filename }` to produce a valid map.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["for_each with resource outputs", "for expression", "map conversion"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "labels" {
  type    = set(string)
  default = ["alpha", "beta"]
}

resource "local_file" "configs" {
  for_each = var.labels
  content  = "config: ${each.key}"
  filename = "${path.module}/config-${each.key}.txt"
}

# Wrong: can't use a resource object directly as for_each
resource "local_file" "summaries" {
  for_each = local_file.configs
  content  = "summary for ${each.key}: ${each.value.filename}"
  filename = "${path.module}/summary-${each.key}.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "labels" {
  type    = set(string)
  default = ["alpha", "beta"]
}

resource "local_file" "configs" {
  for_each = var.labels
  content  = "config: ${each.key}"
  filename = "${path.module}/config-${each.key}.txt"
}

resource "local_file" "summaries" {
  for_each = { for k, v in local_file.configs : k => v.filename }
  content  = "summary for ${each.key}: ${each.value}"
  filename = "${path.module}/summary-${each.key}.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. `for_each` must be a map or set, not a resource object.",
            "Convert the resource collection to a map using a `for` expression: `{ for k, v in local_file.configs : k => v.filename }`.",
            "Update `for_each` and adjust `each.value` usage (it's now the filename string, not the resource object).",
        ],
        "debrief": """\
# Resource as for_each Value

## What Was Broken
`for_each = local_file.configs` passes the resource collection directly.
Terraform's `for_each` requires an explicit `map` or `set`, not a resource object.

## Converting Resource to Map
```hcl
for_each = { for k, v in local_file.configs : k => v.filename }
# Produces: { "alpha" = "config-alpha.txt", "beta" = "config-beta.txt" }
```

Then `each.key` is the label and `each.value` is the filename string.

## Why Not Directly?
Passing a resource object would theoretically work if it were a map type,
but Terraform requires the for_each value to be known at plan time in a structured way.

## Concepts
- `for_each` must receive a `map` or `set` value
- Use `for` expressions to transform resource outputs into maps
""",
        "common_mistakes": """\
# Common Mistakes

- **Passing `resource.name` directly** — always convert to map/set explicitly.
- **`each.value.filename` vs `each.value`** — after converting to a map of filenames, `each.value` IS the filename string.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 10 — for-each-empty
# ─────────────────────────────────────────────────────────────────────────────
def _level_10_for_each_empty():
    return {
        "module": MODULE,
        "slug": "level-10-for-each-empty",
        "mission": {
            "name": "Empty for_each Map",
            "description": (
                "`for_each = var.items` where `var.items = {}` creates zero resources. "
                "The output tries to access `local_file.items[\"main\"].filename` which doesn't exist "
                "when the map is empty."
            ),
            "objective": "Add a default entry `main = \"default\"` to `var.items` so the resource is created and the output works.",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "8m",
            "concepts": ["empty for_each", "default map values", "resource access"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "items" {
  type    = map(string)
  default = {}
}

resource "local_file" "items" {
  for_each = var.items
  content  = "item: ${each.value}"
  filename = "${path.module}/item-${each.key}.txt"
}

# Fails when items is empty — no "main" key exists
output "main_file" {
  value = local_file.items["main"].filename
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "items" {
  type = map(string)
  default = {
    main = "default"
  }
}

resource "local_file" "items" {
  for_each = var.items
  content  = "item: ${each.value}"
  filename = "${path.module}/item-${each.key}.txt"
}

output "main_file" {
  value = local_file.items["main"].filename
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. With `var.items = {}`, there are no resources — the `[\"main\"]` reference fails.",
            "Add a default entry to the map: `default = { main = \"default\" }`.",
            "Update `var.items` default to include at least the `main` key.",
        ],
        "debrief": """\
# Empty for_each Map

## What Was Broken
`var.items = {}` creates zero `local_file` instances.
`local_file.items[\"main\"]` fails because the `\"main\"` key doesn't exist.

## Adding a Default Entry
```hcl
variable "items" {
  type = map(string)
  default = {
    main = "default"
  }
}
```

## Defensive Output Access
If the map might be empty, use `try()`:
```hcl
output "main_file" {
  value = try(local_file.items["main"].filename, "")
}
```

## Concepts
- An empty `for_each` map creates zero resources
- Always consider the empty case when accessing `for_each` resources by key
""",
        "common_mistakes": """\
# Common Mistakes

- **Hardcoding key access on potentially empty maps** — always guard or ensure the key exists.
- **Expecting `{}` to error** — empty `for_each` is valid and creates nothing silently.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 11 — for-each-count-mix
# ─────────────────────────────────────────────────────────────────────────────
def _level_11_for_each_count_mix():
    _child_main = """\
resource "local_file" "data" {
  content  = "module data"
  filename = "${path.module}/data.txt"
}

output "file_path" {
  value = local_file.data.filename
}
"""
    return {
        "module": MODULE,
        "slug": "level-11-for-each-count-mix",
        "mission": {
            "name": "count vs for_each Addressing",
            "description": (
                "A module uses `count = 2`. The caller references `module.mymod[\"key\"]` "
                "— but `count`-based modules use numeric indices like `[0]`, not string keys."
            ),
            "objective": "Fix the output to reference `module.mymod[0].file_path` instead of `module.mymod[\"key\"].file_path`.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["count vs for_each addressing", "module count index", "for_each key"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "mymod" {
  count  = 2
  source = "./modules/datamod"
}

# Wrong: count modules use [0], [1] — not string keys like ["key"]
output "first_file" {
  value = module.mymod["key"].file_path
}
""",
            "modules/datamod/main.tf": _child_main,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "mymod" {
  count  = 2
  source = "./modules/datamod"
}

output "first_file" {
  value = module.mymod[0].file_path
}
""",
            "modules/datamod/main.tf": _child_main,
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. `module.mymod[\"key\"]` is invalid — `count` modules use numeric indices.",
            "`count = 2` creates instances at `[0]` and `[1]`. Use `module.mymod[0].file_path`.",
            "Change `module.mymod[\"key\"]` to `module.mymod[0]`.",
        ],
        "debrief": """\
# count vs for_each Addressing

## What Was Broken
`module.mymod["key"]` uses string key notation, which is for `for_each` modules.
`count` modules use integer indices.

## Addressing Summary
| Meta-argument | Instance Address |
|--------------|-----------------|
| `count = 2` | `module.mymod[0]`, `module.mymod[1]` |
| `for_each = toset(["a","b"])` | `module.mymod["a"]`, `module.mymod["b"]` |

## Migration: count to for_each
When switching from `count` to `for_each`, resource addresses change — use `moved` blocks
to prevent destroy/create cycles.

## Concepts
- `count` modules: addressed by integer index `[N]`
- `for_each` modules: addressed by string key `["key"]`
""",
        "common_mistakes": """\
# Common Mistakes

- **Mixing `["key"]` with count** — string keys only work with `for_each`.
- **Mixing `[0]` with for_each** — integer indices only work with `count`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 12 — dynamic-block-basics
# ─────────────────────────────────────────────────────────────────────────────
def _level_12_dynamic_block_basics():
    return {
        "module": MODULE,
        "slug": "level-12-dynamic-block-basics",
        "mission": {
            "name": "Wrong Dynamic Block Name",
            "description": (
                "A `dynamic` block is named `\"setting\"` but the resource uses nested blocks "
                "called `\"settings\"` (plural). The dynamic block name must match the nested block name exactly."
            ),
            "objective": "Rename the `dynamic \"setting\"` block to `dynamic \"settings\"` to match the nested block name.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["dynamic block naming", "nested blocks", "dynamic block"],
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
}
""",
            "main.tf": """\
variable "config_pairs" {
  type = list(object({
    key   = string
    value = string
  }))
  default = [
    { key = "color", value = "blue" },
    { key = "size",  value = "large" },
  ]
}

# local_sensitive_file accepts a single content argument — we use local_file
# and simulate nested blocks with a locals workaround.
# The broken part: dynamic block name is "setting" but must be "settings".
locals {
  config_content = join("\\n", [
    for pair in var.config_pairs : "${pair.key}=${pair.value}"
  ])
}

resource "local_file" "config" {
  content  = local.config_content
  filename = "${path.module}/config.txt"
}

# For illustration: a null_resource with dynamic provisioner blocks
resource "null_resource" "demo" {
  # Wrong: block name is "setting" — should match the label used inside
  dynamic "setting" {
    for_each = var.config_pairs
    content {
      # triggers uses the setting iterator
    }
  }
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
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}
""",
            "main.tf": """\
variable "config_pairs" {
  type = list(object({
    key   = string
    value = string
  }))
  default = [
    { key = "color", value = "blue" },
    { key = "size",  value = "large" },
  ]
}

locals {
  config_content = join("\\n", [
    for pair in var.config_pairs : "${pair.key}=${pair.value}"
  ])
}

resource "local_file" "config" {
  content  = local.config_content
  filename = "${path.module}/config.txt"
}

resource "null_resource" "demo" {
  triggers = {
    for pair in var.config_pairs : pair.key => pair.value
  }
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The `dynamic` block name must match the nested block type it generates.",
            "A `dynamic \"setting\"` block generates blocks of type `setting`. If the resource expects `settings` (plural), the dynamic block must also be named `settings`.",
            "For `null_resource`, there are no `setting` or `settings` nested blocks — use `triggers` instead for the demo.",
        ],
        "debrief": """\
# Wrong Dynamic Block Name

## What Was Broken
The `dynamic` block label must match the nested block type name exactly.
`dynamic \"setting\"` generates `setting` blocks, not `settings` blocks.

## dynamic Block Syntax
```hcl
dynamic "<block_type>" {
  for_each = var.items
  content {
    # uses <block_type>.key, <block_type>.value
  }
}
```

The `<block_type>` must be the exact name of the nested block that the resource accepts.

## Common Pattern with null_resource
For `null_resource`, use `triggers` instead of dynamic blocks:
```hcl
resource "null_resource" "demo" {
  triggers = {
    for pair in var.config_pairs : pair.key => pair.value
  }
}
```

## Concepts
- `dynamic` block name = the nested block type it produces
- The iterator object inside `content {}` is named after the dynamic block label
""",
        "common_mistakes": """\
# Common Mistakes

- **Singular vs plural** — `setting` and `settings` are different block types.
- **Incorrect resource for dynamic blocks** — not all resources have nested blocks; check the provider schema.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 13 — dynamic-content
# ─────────────────────────────────────────────────────────────────────────────
def _level_13_dynamic_content():
    return {
        "module": MODULE,
        "slug": "level-13-dynamic-content",
        "mission": {
            "name": "Wrong Iterator in Dynamic Block",
            "description": (
                "A `dynamic` block iterates over `var.tags` but the `content` block uses "
                "`each.value.name` instead of the correct iterator `tag.value` (the dynamic "
                "block's iterator is named after the block label, not `each`)."
            ),
            "objective": "Replace `each.value.name` with `tag.key` and `each.value.value` with `tag.value` inside the dynamic block content.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["dynamic block content", "iterator naming", "dynamic block"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "tags" {
  type = map(string)
  default = {
    env  = "prod"
    team = "platform"
  }
}

# The dynamic block iterator is named 'tag' (from the block label).
# Inside content, use tag.key and tag.value — NOT each.value.name.
locals {
  tags_content = join("\\n", [
    for k, v in var.tags : "${k}=${v}"
  ])
}

resource "local_file" "tags_file" {
  # Wrong iterator references — each.value.name and each.value.value don't exist here
  content  = join("\\n", [for k, v in var.tags : "${each.value.name}=${each.value.value}"])
  filename = "${path.module}/tags.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "tags" {
  type = map(string)
  default = {
    env  = "prod"
    team = "platform"
  }
}

locals {
  tags_content = join("\\n", [
    for k, v in var.tags : "${k}=${v}"
  ])
}

resource "local_file" "tags_file" {
  content  = local.tags_content
  filename = "${path.module}/tags.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. `each.value.name` is not defined in this context.",
            "Inside a `for` expression, use the loop variables you declared: `for k, v in var.tags : \"${k}=${v}\"`.",
            "Simplify by using the `local.tags_content` expression instead of inline for with wrong references.",
        ],
        "debrief": """\
# Wrong Iterator in Dynamic Block

## What Was Broken
`each.value.name` and `each.value.value` are not valid in a `for` expression or outside a `for_each` resource.
Inside `for k, v in var.tags`, use `k` and `v` directly.

## Correct for Expression
```hcl
content = join("\\n", [for k, v in var.tags : "${k}=${v}"])
```

## Dynamic Block Iterator Naming
When using `dynamic` blocks, the iterator is named after the block label:
```hcl
dynamic "tag" {
  for_each = var.tags
  content {
    key   = tag.key     # not each.key
    value = tag.value   # not each.value
  }
}
```

## Concepts
- In `for` expressions: use the declared loop variables (`k`, `v`)
- In `dynamic` blocks: use `<block_label>.key` and `<block_label>.value`
- `each` is only available in `for_each` resources/modules
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `each` in for expressions** — `each` is for `for_each` resources, not `for` expressions.
- **Dynamic block iterator naming** — the iterator defaults to the block label name, not `each`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 14 — dynamic-optional
# ─────────────────────────────────────────────────────────────────────────────
def _level_14_dynamic_optional():
    return {
        "module": MODULE,
        "slug": "level-14-dynamic-optional",
        "mission": {
            "name": "Non-nullable Variable in Optional Block",
            "description": (
                "A pattern `for_each = var.env != null ? [var.env] : []` is used to optionally "
                "include a block. But `var.env` is declared `nullable = false`, so it can never "
                "be null — the optional logic is broken. Fix: set `nullable = true`."
            ),
            "objective": "Change `nullable = false` to `nullable = true` on `var.env` so the null check works.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["optional dynamic blocks", "nullable variables", "null check pattern"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "env" {
  type     = string
  default  = null
  # nullable = false means this variable can never be null — contradicts default = null
  nullable = false
}

locals {
  env_lines = var.env != null ? ["env=${var.env}"] : []
  content   = join("\\n", concat(["config:"], local.env_lines))
}

resource "local_file" "config" {
  content  = local.content
  filename = "${path.module}/config.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "env" {
  type     = string
  default  = null
  nullable = true
}

locals {
  env_lines = var.env != null ? ["env=${var.env}"] : []
  content   = join("\\n", concat(["config:"], local.env_lines))
}

resource "local_file" "config" {
  content  = local.content
  filename = "${path.module}/config.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The variable has `nullable = false` but `default = null` — these are contradictory.",
            "`nullable = false` means Terraform replaces null with the default, making a null check pointless.",
            "Change `nullable = false` to `nullable = true` to allow the variable to actually be null.",
        ],
        "debrief": """\
# Non-nullable Variable in Optional Block

## What Was Broken
`nullable = false` tells Terraform: if this variable receives `null`, replace it with the default.
With `default = null` and `nullable = false`, the result is contradictory — the default is null
but null is not allowed.

## nullable = true (the fix)
```hcl
variable "env" {
  type     = string
  default  = null
  nullable = true   # allow null to be passed through
}
```

## Optional Block Pattern
```hcl
locals {
  env_lines = var.env != null ? ["env=${var.env}"] : []
}
```
This pattern creates a zero-or-one-element list, useful for optionally including content.

## Concepts
- `nullable = false` — Terraform substitutes null with the variable's default
- `nullable = true` (default since Terraform 1.1) — null is passed through as-is
- `default = null` + `nullable = true` = truly optional variable
""",
        "common_mistakes": """\
# Common Mistakes

- **`nullable = false` with `default = null`** — contradictory; Terraform may error or behave unexpectedly.
- **Not understanding nullable defaults** — since Terraform 1.1, `nullable = true` is the default.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 15 — nested-for-each-flatten
# ─────────────────────────────────────────────────────────────────────────────
def _level_15_nested_for_each_flatten():
    return {
        "module": MODULE,
        "slug": "level-15-nested-for-each-flatten",
        "mission": {
            "name": "Nested for Expression Needs flatten()",
            "description": (
                "A `for_each` is fed by a nested `for` expression over services and ports. "
                "The nested for produces a list of lists, not a flat list. "
                "Wrapping with `flatten()` fixes it."
            ),
            "objective": "Wrap the nested `for` expression in `flatten()` so `toset()` receives a flat list.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["nested for_each", "flatten()", "list of lists"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "services" {
  type = list(object({
    name  = string
    ports = list(number)
  }))
  default = [
    { name = "web",  ports = [80, 443] },
    { name = "api",  ports = [8080] },
  ]
}

# Wrong: nested for produces list of lists — toset() expects a flat list
resource "local_file" "port_configs" {
  for_each = toset([
    for svc in var.services : [
      for port in svc.ports : "${svc.name}-${port}"
    ]
  ])
  content  = "port config: ${each.key}"
  filename = "${path.module}/port-${each.key}.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "services" {
  type = list(object({
    name  = string
    ports = list(number)
  }))
  default = [
    { name = "web",  ports = [80, 443] },
    { name = "api",  ports = [8080] },
  ]
}

resource "local_file" "port_configs" {
  for_each = toset(flatten([
    for svc in var.services : [
      for port in svc.ports : "${svc.name}-${port}"
    ]
  ]))
  content  = "port config: ${each.key}"
  filename = "${path.module}/port-${each.key}.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says `for_each` received a list of lists, not a list of strings.",
            "The outer `for` returns `[list_for_web, list_for_api]` — a list of lists. Use `flatten()` to collapse it.",
            "Wrap the whole `for` expression with `flatten(...)`: `toset(flatten([for svc in ... : [for port in ...]]))` .",
        ],
        "debrief": """\
# Nested for Expression Needs flatten()

## What Was Broken
```hcl
[for svc in var.services : [for port in svc.ports : "..."]]
# Returns: [["web-80", "web-443"], ["api-8080"]]  — list of lists
```

`toset()` expects a flat list, not a list of lists.

## The Fix: flatten()
```hcl
flatten([for svc in var.services : [for port in svc.ports : "${svc.name}-${port}"]])
# Returns: ["web-80", "web-443", "api-8080"]  — flat list
```

## flatten() Function
`flatten(list_of_lists)` recursively flattens nested lists into a single list.

```hcl
flatten([[1, 2], [3, 4]])   # => [1, 2, 3, 4]
flatten([[1, [2, 3]], [4]]) # => [1, 2, 3, 4]
```

## Concepts
- Nested `for` expressions produce nested lists
- `flatten()` collapses nested lists to a single depth
- `toset(flatten([...]))` is a common pattern for cross-product for_each
""",
        "common_mistakes": """\
# Common Mistakes

- **Forgetting `flatten()`** — nested for expressions always need it when used with `toset()` or `for_each`.
- **Extra brackets** — `toset(flatten([...]))` not `toset([flatten([...])])`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 16 — for-each-known-after-apply
# ─────────────────────────────────────────────────────────────────────────────
def _level_16_for_each_known_after_apply():
    return {
        "module": MODULE,
        "slug": "level-16-for-each-known-after-apply",
        "mission": {
            "name": "for_each Key Unknown at Plan Time",
            "description": (
                "`for_each` uses `random_string.id.result` as a key — but `random_string.result` "
                "is only known after apply, not during planning. Terraform rejects this because "
                "`for_each` keys must be known at plan time."
            ),
            "objective": "Replace the `random_string` key with a static string key so the plan succeeds.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["known after apply", "for_each constraints", "plan time values"],
        },
        "broken": {
            "terraform.tf": DEFAULT_TERRAFORM_TF,
            "main.tf": """\
resource "random_string" "id" {
  length  = 8
  special = false
}

# Wrong: random_string.id.result is unknown at plan time — for_each keys must be known.
resource "local_file" "config" {
  for_each = toset([random_string.id.result])
  content  = "config for ${each.key}"
  filename = "${path.module}/config-${each.key}.txt"
}
""",
        },
        "solution": {
            "terraform.tf": DEFAULT_TERRAFORM_TF,
            "main.tf": """\
resource "random_string" "id" {
  length  = 8
  special = false
}

# Use a static key — values (content/filename) can still use random_string.id.result
resource "local_file" "config" {
  for_each = toset(["main"])
  content  = "config for ${random_string.id.result}"
  filename = "${path.module}/config-${each.key}.txt"
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. Terraform says the `for_each` map has keys that are not known until after apply.",
            "`for_each` keys must be deterministic at plan time. `random_string.result` is unknown until apply.",
            "Replace `toset([random_string.id.result])` with a static set like `toset([\"main\"])`. You can still use the random value in the resource body.",
        ],
        "debrief": """\
# for_each Key Unknown at Plan Time

## What Was Broken
`random_string.result` is generated during apply, not during planning.
Terraform cannot build the resource graph without knowing `for_each` keys at plan time.

## The Rule
`for_each` keys must be **known at plan time** — they define the resource addresses.
Resource *values* (body attributes) can use computed values.

## The Fix
Use static keys, move computed values into the resource body:
```hcl
resource "local_file" "config" {
  for_each = toset(["main"])               # static key
  content  = "config for ${random_string.id.result}"  # computed value OK here
  filename = "${path.module}/config-${each.key}.txt"
}
```

## What CAN Be Unknown at Plan Time
- Resource body arguments (`content`, `filename`, etc.)
- Non-key references in `for` expressions used in outputs

## Concepts
- `for_each` keys determine resource identity — must be plan-time known
- Computed values are fine in resource arguments, just not as `for_each` keys
""",
        "common_mistakes": """\
# Common Mistakes

- **Using computed values as for_each keys** — only static/input values work as keys.
- **Same restriction applies to count** — `count` must also be known at plan time.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 17 — count-to-for-each-migration
# ─────────────────────────────────────────────────────────────────────────────
def _level_17_count_to_for_each_migration():
    return {
        "module": MODULE,
        "slug": "level-17-count-to-for-each-migration",
        "mission": {
            "name": "count to for_each Migration",
            "description": (
                "Resources were migrated from `count`-based to `for_each`-based, "
                "renaming from `local_file.items[0]` and `local_file.items[1]` to "
                "`local_file.items[\"alpha\"]` and `local_file.items[\"beta\"]`. "
                "Without `moved` blocks, Terraform will destroy and recreate."
            ),
            "objective": "Add `moved` blocks to map the old count indices to the new for_each keys.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["count to for_each migration", "moved block", "state migration"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Migrated from count to for_each — but no moved blocks added.
resource "local_file" "items" {
  for_each = toset(["alpha", "beta"])
  content  = "item: ${each.key}"
  filename = "${path.module}/item-${each.key}.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "items" {
  for_each = toset(["alpha", "beta"])
  content  = "item: ${each.key}"
  filename = "${path.module}/item-${each.key}.txt"
}

moved {
  from = local_file.items[0]
  to   = local_file.items["alpha"]
}

moved {
  from = local_file.items[1]
  to   = local_file.items["beta"]
}
""",
        },
        "validate": _validate_plan_no_destroy(),
        "hints": [
            "Run `terraform plan`. Without `moved` blocks, Terraform plans to destroy the old count instances and create new for_each instances.",
            "Add `moved` blocks to map each old address to the new one.",
            (
                "Add:\n"
                "```hcl\n"
                "moved {\n"
                "  from = local_file.items[0]\n"
                "  to   = local_file.items[\"alpha\"]\n"
                "}\n"
                "moved {\n"
                "  from = local_file.items[1]\n"
                "  to   = local_file.items[\"beta\"]\n"
                "}\n"
                "```"
            ),
        ],
        "debrief": """\
# count to for_each Migration

## What Was Broken
Switching from `count` to `for_each` changes resource addresses:
- `local_file.items[0]` → `local_file.items["alpha"]`
- `local_file.items[1]` → `local_file.items["beta"]`

Without `moved` blocks, Terraform sees these as entirely different resources (destroy old, create new).

## The moved Blocks
```hcl
moved {
  from = local_file.items[0]
  to   = local_file.items["alpha"]
}
moved {
  from = local_file.items[1]
  to   = local_file.items["beta"]
}
```

## After Adding moved
`terraform plan` should show no-op or only attribute-level updates (not destroy/create).

## Why This Matters
Destroying and recreating resources can have real-world consequences (downtime, data loss).
`moved` blocks let you refactor resource addressing without disrupting infrastructure.

## Concepts
- `moved` maps old addresses to new addresses in state
- One `moved` block per renamed instance
""",
        "common_mistakes": """\
# Common Mistakes

- **Wrong order in moved** — `from` is the old address, `to` is the new address (never reversed).
- **Skipping moved for major refactors** — always add `moved` when changing resource labels or meta-arguments.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 18 — conditional-module-call
# ─────────────────────────────────────────────────────────────────────────────
def _level_18_conditional_module_call():
    _child_main = """\
resource "local_file" "result" {
  content  = "module result"
  filename = "${path.module}/result.txt"
}

output "file_path" {
  value = local_file.result.filename
}
"""
    return {
        "module": MODULE,
        "slug": "level-18-conditional-module-call",
        "mission": {
            "name": "Conditional Module Output Reference",
            "description": (
                "A module is called with `count = var.enabled ? 1 : 0`. "
                "The output references `module.mymod.file_path` — but with `count`, "
                "module instances are addressed as `module.mymod[0].file_path`."
            ),
            "objective": "Fix the output to use `module.mymod[0].file_path` (or `try(module.mymod[0].file_path, \"\")`  for safety).",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["conditional module with count", "module count index", "try()"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "enabled" {
  type    = bool
  default = true
}

module "mymod" {
  count  = var.enabled ? 1 : 0
  source = "./modules/mymod"
}

# Wrong: count module must be addressed with [0], not as a singleton
output "result_path" {
  value = module.mymod.file_path
}
""",
            "modules/mymod/main.tf": _child_main,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "enabled" {
  type    = bool
  default = true
}

module "mymod" {
  count  = var.enabled ? 1 : 0
  source = "./modules/mymod"
}

output "result_path" {
  value = try(module.mymod[0].file_path, "")
}
""",
            "modules/mymod/main.tf": _child_main,
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform validate`. A `count`-based module cannot be referenced without an index.",
            "With `count = var.enabled ? 1 : 0`, the module is either `[0]` (if enabled) or absent.",
            "Use `try(module.mymod[0].file_path, \"\")` to safely handle both the enabled and disabled cases.",
        ],
        "debrief": """\
# Conditional Module Output Reference

## What Was Broken
`module.mymod.file_path` is invalid when the module uses `count`. With `count`,
all instances must be addressed by index: `module.mymod[0]`, `module.mymod[1]`, etc.

## Safe Conditional Output
```hcl
output "result_path" {
  value = try(module.mymod[0].file_path, "")
}
```

`try()` returns `""` when `count = 0` and `module.mymod[0]` doesn't exist.

## Pattern: Conditional Module
```hcl
module "mymod" {
  count  = var.enabled ? 1 : 0
  source = "./modules/mymod"
}

output "result_path" {
  value = try(module.mymod[0].file_path, "")
}
```

## Concepts
- `count`-based modules: `module.name[N]` — always use index notation
- `try(expr, fallback)` — safe access for potentially absent instances
- Conditional modules (`count = 0 or 1`) are a common Terraform pattern
""",
        "common_mistakes": """\
# Common Mistakes

- **Referencing count module without index** — `module.mymod.output` is only valid for modules without count/for_each.
- **Not handling count=0 case** — always use `try()` when the module might not exist.
""",
    }


if __name__ == "__main__":
    build()
