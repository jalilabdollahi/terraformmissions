#!/usr/bin/env python3
"""Module 3 — Variables & Outputs (18 levels, Beginner-Intermediate)."""
from __future__ import annotations

from scripts.build_utils import (
    LOCAL_ONLY_TF,
    print_done,
    validate_tf_plan,
    validate_tf_validate,
    validate_custom,
    write_level,
)

MODULE = "module-3-variables-outputs"


def build() -> int:
    levels = [
        _level_01_string_variable(),
        _level_02_number_variable(),
        _level_03_bool_variable(),
        _level_04_list_variable(),
        _level_05_map_variable(),
        _level_06_object_variable(),
        _level_07_set_variable(),
        _level_08_tuple_variable(),
        _level_09_variable_validation(),
        _level_10_validation_message(),
        _level_11_nullable_variable(),
        _level_12_sensitive_output(),
        _level_13_output_reference(),
        _level_14_output_depends_on(),
        _level_15_tfvars_file(),
        _level_16_variable_precedence(),
        _level_17_complex_object_output(),
        _level_18_precondition_output(),
    ]
    for lvl in levels:
        write_level(lvl)
    print_done(MODULE, len(levels))
    return len(levels)


# ─────────────────────────────────────────────────────────────────────────────
# Level 1 — string-variable
# ─────────────────────────────────────────────────────────────────────────────
def _level_01_string_variable():
    return {
        "module": MODULE,
        "slug": "level-1-string-variable",
        "mission": {
            "name": "Type Mismatch: String Masquerading as Number",
            "description": (
                "A variable is declared as `type = number` but its default is `\"hello\"` — "
                "a string. Terraform's type checker rejects this mismatch."
            ),
            "objective": "Fix the type declaration so `terraform validate` passes.",
            "xp": 100,
            "difficulty": "beginner",
            "expected_time": "5m",
            "concepts": ["variable types", "type mismatch"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# BUG: type = number but default = "hello" (a string). These conflict.

variable "app_name" {
  type    = number
  default = "hello"
}

resource "local_file" "info" {
  content  = var.app_name
  filename = "${path.module}/info.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "app_name" {
  type    = string
  default = "hello"
}

resource "local_file" "info" {
  content  = var.app_name
  filename = "${path.module}/info.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says the default value is not compatible with the declared type.",
            "The value `\"hello\"` is a string, but the variable is declared as `type = number`. One of them must change.",
            "Change `type = number` to `type = string` to match the default value.",
        ],
        "debrief": """\
# Type Mismatch: String Masquerading as Number

## What Was Broken
The variable declared `type = number` but provided `default = "hello"`. The string `"hello"`
cannot be converted to a number, so Terraform reports a type mismatch during validate.

## The Fix
```hcl
variable "app_name" {
  type    = string
  default = "hello"
}
```

## Terraform Variable Types

| Type keyword      | Example default value |
|------------------|-----------------------|
| `string`          | `"hello"`             |
| `number`          | `42`, `3.14`          |
| `bool`            | `true`, `false`       |
| `list(string)`    | `["a", "b"]`          |
| `map(string)`     | `{ key = "val" }`     |
| `object({...})`   | `{ name = "app" }`    |
| `set(string)`     | `["a", "b"]`          |
| `tuple([...])`    | `["hello", 42]`       |

## Why It Matters
Declaring an explicit `type` constraint makes variables self-documenting and prevents callers from
passing the wrong kind of value. The type check happens at validate time — before any resources
are created.
""",
        "common_mistakes": """\
# Common Mistakes

- **Declaring `type = number` for names/labels** — use `string` for text values.
- **Omitting `type` entirely** — without a type, Terraform accepts any value and type errors appear later.
- **Confusing `type` constraint with `validation` block** — `type` checks the data type; `validation` checks the logical value.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 2 — number-variable
# ─────────────────────────────────────────────────────────────────────────────
def _level_02_number_variable():
    return {
        "module": MODULE,
        "slug": "level-2-number-variable",
        "mission": {
            "name": "Quoted Numbers Are Not Numbers",
            "description": (
                "A variable has `type = number` and `default = \"42\"` — the number is wrapped "
                "in quotes, making it a string. Terraform may coerce this, but it is considered "
                "a type mismatch and should be corrected."
            ),
            "objective": "Fix the default value so it is an unquoted number and `terraform validate` passes.",
            "xp": 100,
            "difficulty": "beginner",
            "expected_time": "5m",
            "concepts": ["variable types", "type mismatch"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# BUG: default = "42" is a string, not a number. The type is declared as number.

variable "replica_count" {
  type    = number
  default = "42"
}

output "replica_count" {
  value = var.replica_count
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "replica_count" {
  type    = number
  default = 42
}

output "replica_count" {
  value = var.replica_count
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says the default value is a string where a number is expected.",
            "In HCL, `\"42\"` is a string literal. `42` (without quotes) is a number literal. The `type = number` declaration requires the latter.",
            "Change `default = \"42\"` to `default = 42` by removing the quotes.",
        ],
        "debrief": """\
# Quoted Numbers Are Not Numbers

## What Was Broken
`default = "42"` is a string in HCL, not a number. The `type = number` constraint requires
an unquoted numeric literal.

## The Fix
```hcl
variable "replica_count" {
  type    = number
  default = 42
}
```

## HCL Literal Types at a Glance

| Value     | Type   |
|----------|--------|
| `42`      | number |
| `"42"`    | string |
| `true`    | bool   |
| `"true"`  | string |
| `3.14`    | number |
| `"3.14"`  | string |

## Why It Matters
While Terraform sometimes attempts automatic type coercion (e.g., `"42"` → `42`), it is not
guaranteed and varies between versions. Always use the correct literal type to avoid subtle bugs.
""",
        "common_mistakes": """\
# Common Mistakes

- **Quoting numbers** — `"42"` is a string; `42` is a number.
- **Quoting booleans** — `"true"` is a string; `true` is a boolean.
- **Relying on implicit coercion** — don't depend on Terraform to silently convert types.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 3 — bool-variable
# ─────────────────────────────────────────────────────────────────────────────
def _level_03_bool_variable():
    return {
        "module": MODULE,
        "slug": "level-3-bool-variable",
        "mission": {
            "name": "False is Not a String",
            "description": (
                "A variable has `type = bool` and `default = \"false\"` — the boolean is "
                "wrapped in quotes, making it a string. Fix the default value."
            ),
            "objective": "Fix the default value so it is an unquoted boolean and `terraform validate` passes.",
            "xp": 100,
            "difficulty": "beginner",
            "expected_time": "5m",
            "concepts": ["variable types", "bool", "type mismatch"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# BUG: default = "false" is a string, not a boolean.

variable "enable_logging" {
  type    = bool
  default = "false"
}

output "logging_enabled" {
  value = var.enable_logging
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "enable_logging" {
  type    = bool
  default = false
}

output "logging_enabled" {
  value = var.enable_logging
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says the default value is a string where a bool is expected.",
            "In HCL, `\"false\"` is a string. The boolean literals are `true` and `false` — without quotes.",
            "Change `default = \"false\"` to `default = false` by removing the quotes.",
        ],
        "debrief": """\
# False is Not a String

## What Was Broken
`default = "false"` is a string literal. The `type = bool` constraint requires an unquoted boolean
literal (`true` or `false`).

## The Fix
```hcl
variable "enable_logging" {
  type    = bool
  default = false
}
```

## Boolean Literals in HCL

| Value     | Type   | Meaning |
|----------|--------|---------|
| `true`    | bool   | Correct boolean true |
| `false`   | bool   | Correct boolean false |
| `"true"`  | string | Wrong — a string, not a bool |
| `"false"` | string | Wrong — a string, not a bool |

## Why It Matters
Using `"false"` (string) instead of `false` (bool) is one of the most common type mistakes in
Terraform. The string `"false"` is truthy in many languages — but Terraform's type system rejects
it outright when `type = bool` is declared.
""",
        "common_mistakes": """\
# Common Mistakes

- **Quoting booleans** — `"true"` and `"false"` are strings, not booleans.
- **Using `0`/`1` for booleans** — HCL booleans are `true`/`false`, not integers.
- **Forgetting that `\"false\"` may behave as truthy in other contexts** — always use the correct type.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 4 — list-variable
# ─────────────────────────────────────────────────────────────────────────────
def _level_04_list_variable():
    return {
        "module": MODULE,
        "slug": "level-4-list-variable",
        "mission": {
            "name": "One Number Ruins the List",
            "description": (
                "A variable is declared as `type = list(string)` but its default contains "
                "a number: `[\"a\", \"b\", 3]`. The number `3` must be the string `\"3\"`."
            ),
            "objective": "Fix the default value so all elements are strings and `terraform validate` passes.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["list(string)", "type mismatch"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# BUG: The third element (3) is a number, not a string.
# list(string) requires ALL elements to be strings.

variable "tags" {
  type    = list(string)
  default = ["a", "b", 3]
}

output "tags" {
  value = var.tags
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "tags" {
  type    = list(string)
  default = ["a", "b", "3"]
}

output "tags" {
  value = var.tags
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says element index 2 is a number but a string is required.",
            "`list(string)` means every element must be a string. The value `3` (unquoted) is a number.",
            "Change `3` to `\"3\"` — wrap the number in double quotes to make it a string.",
        ],
        "debrief": """\
# One Number Ruins the List

## What Was Broken
`list(string)` enforces that **every element** is a string. The value `3` (without quotes) is a
number literal, violating the constraint.

## The Fix
```hcl
default = ["a", "b", "3"]
```

## `list` vs `tuple`

| Type           | Constraint |
|---------------|------------|
| `list(string)` | All elements must be the same type (string) |
| `tuple([string, string, number])` | Each element has its own declared type |

If you need a list where elements can be different types, use `tuple`.

## Why It Matters
Typed collections (`list(string)`, `map(number)`, etc.) enforce consistency. A single wrong-typed
element fails the entire variable. Check every element when setting a default for a typed list.
""",
        "common_mistakes": """\
# Common Mistakes

- **Mixing types in `list(string)`** — every element must be a string.
- **Forgetting that numeric-looking values need quotes** — `3` ≠ `"3"` in HCL.
- **Using `list` without a type parameter** — `list` alone is deprecated; prefer `list(string)`, `list(number)`, etc.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 5 — map-variable
# ─────────────────────────────────────────────────────────────────────────────
def _level_05_map_variable():
    return {
        "module": MODULE,
        "slug": "level-5-map-variable",
        "mission": {
            "name": "Mixed Types in a String Map",
            "description": (
                "A variable is declared as `type = map(string)` but its default has mixed types: "
                "`{ a = \"x\", b = 2 }`. The value `2` is a number, not a string."
            ),
            "objective": "Fix the default value so all map values are strings and `terraform validate` passes.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["map(string)", "type mismatch"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# BUG: map(string) requires all values to be strings.
# The value for key "b" is the number 2, not a string.

variable "labels" {
  type = map(string)
  default = {
    a = "x"
    b = 2
  }
}

output "labels" {
  value = var.labels
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "labels" {
  type = map(string)
  default = {
    a = "x"
    b = "2"
  }
}

output "labels" {
  value = var.labels
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says the value for key `b` is a number but a string is required.",
            "`map(string)` means every value in the map must be a string, regardless of what the value looks like.",
            "Change `b = 2` to `b = \"2\"` — wrap the number in double quotes.",
        ],
        "debrief": """\
# Mixed Types in a String Map

## What Was Broken
`map(string)` enforces that **every value** in the map is a string. The value `2` (unquoted number)
for key `b` violates this constraint.

## The Fix
```hcl
default = {
  a = "x"
  b = "2"
}
```

## `map` vs `object`

| Type                          | Constraint |
|------------------------------|------------|
| `map(string)`                 | All values must be the same type (string) |
| `object({ a = string, b = number })` | Each key has its own declared type |

If you need map values of different types, use `object({...})`.

## Why It Matters
`map(string)` appears frequently in Terraform for tags, environment variables, and configuration
maps. Every value must be a string — even numeric-looking ones like version numbers or counts.
""",
        "common_mistakes": """\
# Common Mistakes

- **Mixing types in `map(string)`** — every value must be a string.
- **Using `map` without a type parameter** — `map` alone is deprecated; use `map(string)`, `map(number)`, etc.
- **Confusing `map(string)` with `object({...})`** — use `object` when keys have different types.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 6 — object-variable
# ─────────────────────────────────────────────────────────────────────────────
def _level_06_object_variable():
    return {
        "module": MODULE,
        "slug": "level-6-object-variable",
        "mission": {
            "name": "Object Missing a Required Key",
            "description": (
                "A variable has `type = object({ name = string, port = number })` but its "
                "default is `{ name = \"app\" }` — missing the required `port` key."
            ),
            "objective": "Add the missing `port` key to the default so `terraform validate` passes.",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["object type", "required attributes"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# BUG: default is missing the required "port" key defined in the object type.

variable "service" {
  type = object({
    name = string
    port = number
  })
  default = {
    name = "app"
  }
}

output "service_name" {
  value = var.service.name
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "service" {
  type = object({
    name = string
    port = number
  })
  default = {
    name = "app"
    port = 8080
  }
}

output "service_name" {
  value = var.service.name
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says the default value is missing a required attribute.",
            "An `object` type specifies the exact keys and their types. Every key declared in the type must appear in the default value.",
            "Add `port = 8080` to the default object to satisfy the `port = number` requirement.",
        ],
        "debrief": """\
# Object Missing a Required Key

## What Was Broken
The `object` type constraint declares two required keys: `name` (string) and `port` (number).
The default value only provided `name`, leaving `port` missing.

## The Fix
```hcl
default = {
  name = "app"
  port = 8080
}
```

## `object` Type Rules
- Every key declared in `object({...})` is **required** in any value assigned to the variable
- Extra keys NOT declared in the type are **rejected** (unless using `optional()`)
- Each key's value must match its declared type

## Optional Keys (Terraform >= 1.3)
```hcl
type = object({
  name = string
  port = optional(number, 8080)  # optional with default
})
```

With `optional()`, the key can be omitted from the default and caller values.

## Why It Matters
`object` types are strict by default — all declared keys are required. This is intentional:
it forces callers to make all required choices explicit.
""",
        "common_mistakes": """\
# Common Mistakes

- **Missing required object keys** — every non-optional key must be provided.
- **Wrong type for a key** — `port = "8080"` (string) fails when `port = number` is declared.
- **Forgetting `optional()` for truly optional keys** — available in Terraform >= 1.3.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 7 — set-variable
# ─────────────────────────────────────────────────────────────────────────────
def _level_07_set_variable():
    return {
        "module": MODULE,
        "slug": "level-7-set-variable",
        "mission": {
            "name": "Sets Don't Allow Duplicates",
            "description": (
                "A variable has `type = set(string)` with `default = [\"a\", \"b\", \"a\"]`. "
                "Sets do not allow duplicate elements — the duplicate `\"a\"` is invalid."
            ),
            "objective": "Remove the duplicate element so `terraform validate` passes.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["set type", "uniqueness"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# BUG: set(string) does not allow duplicate elements.
# "a" appears twice in the default value.

variable "unique_tags" {
  type    = set(string)
  default = ["a", "b", "a"]
}

output "unique_tags" {
  value = var.unique_tags
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "unique_tags" {
  type    = set(string)
  default = ["a", "b"]
}

output "unique_tags" {
  value = var.unique_tags
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says the default value contains duplicate elements.",
            "A `set` is an unordered collection of **unique** values. The value `\"a\"` appears twice, which violates the uniqueness constraint.",
            "Remove one of the duplicate `\"a\"` entries so that the default is `[\"a\", \"b\"]`.",
        ],
        "debrief": """\
# Sets Don't Allow Duplicates

## What Was Broken
`set(string)` enforces that all elements are unique. The default `["a", "b", "a"]` contains `"a"`
twice, violating this constraint.

## The Fix
```hcl
default = ["a", "b"]
```

## `list` vs `set`

| Feature        | `list(string)` | `set(string)` |
|---------------|----------------|---------------|
| Order          | Preserved      | Not guaranteed |
| Duplicates     | Allowed        | Not allowed    |
| Index access   | `var.x[0]`     | Not supported  |
| Use with `for_each` | Requires `toset()` | Direct use |

## When to Use `set`
Use `set` when:
- You need uniqueness enforced
- Order doesn't matter
- You plan to use the variable with `for_each`

## Why It Matters
`set` is commonly used with `for_each` to create one resource per unique value. Duplicate elements
would create ambiguous resource addressing.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `set` when order matters** — sets are unordered; use `list` if order is important.
- **Accidentally including duplicates** — review all elements when declaring a set default.
- **Forgetting `toset()` when using a `list` with `for_each`** — `for_each` requires a set or map.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 8 — tuple-variable
# ─────────────────────────────────────────────────────────────────────────────
def _level_08_tuple_variable():
    return {
        "module": MODULE,
        "slug": "level-8-tuple-variable",
        "mission": {
            "name": "Tuples Need Exact Types",
            "description": (
                "A variable has `type = tuple([string, number])` but `default = [\"hello\", \"world\"]`. "
                "The second element should be a number, not a string."
            ),
            "objective": "Fix the second element so `terraform validate` passes.",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["tuple type"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# BUG: tuple([string, number]) requires the second element to be a number.
# "world" is a string, not a number.

variable "app_info" {
  type    = tuple([string, number])
  default = ["hello", "world"]
}

output "app_name" {
  value = var.app_info[0]
}

output "app_version" {
  value = var.app_info[1]
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "app_info" {
  type    = tuple([string, number])
  default = ["hello", 42]
}

output "app_name" {
  value = var.app_info[0]
}

output "app_version" {
  value = var.app_info[1]
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says element index 1 must be a number, not a string.",
            "`tuple([string, number])` declares the type of each element by position: index 0 must be a string and index 1 must be a number.",
            "Change `\"world\"` to `42` (or any number without quotes).",
        ],
        "debrief": """\
# Tuples Need Exact Types

## What Was Broken
`tuple([string, number])` declares positional types: index 0 must be a `string`, index 1 must
be a `number`. The default `["hello", "world"]` provides `"world"` (a string) for position 1.

## The Fix
```hcl
default = ["hello", 42]
```

## `tuple` vs `list`

| Feature        | `list(string)` | `tuple([string, number])` |
|---------------|----------------|--------------------------|
| Element types  | All same       | Each position has its own type |
| Length         | Variable       | Fixed (must match declaration) |
| Index access   | `var.x[0]`     | `var.x[0]`                |

## Tuple Use Cases
Tuples are useful when you need a fixed-length, heterogeneous sequence:
```hcl
# [host, port]
variable "endpoint" {
  type    = tuple([string, number])
  default = ["localhost", 8080]
}
```

## Why It Matters
Tuples enforce both the **number** of elements and the **type** of each positional element.
This makes them useful for strongly-typed fixed-structure values.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using a string where a number is expected in a tuple** — each position has an explicit type.
- **Wrong number of elements** — a tuple's length must exactly match the declaration.
- **Using `tuple` when `object` is clearer** — for named fields, `object({...})` is more readable.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 9 — variable-validation
# ─────────────────────────────────────────────────────────────────────────────
def _level_09_variable_validation():
    return {
        "module": MODULE,
        "slug": "level-9-variable-validation",
        "mission": {
            "name": "The Condition Always Fails",
            "description": (
                "A variable has a `validation` block with "
                "`condition = var.env == \"prod\"`. "
                "The default value is `\"dev\"`, so the condition is always false and "
                "terraform plan fails with the validation error message."
            ),
            "objective": "Fix the `condition` to accept `\"dev\"`, `\"staging\"`, and `\"prod\"` so `terraform plan` succeeds with the default value.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["validation block", "condition"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# BUG: condition only accepts "prod", but default is "dev".
# terraform plan fails because the default violates its own validation.

variable "env" {
  type    = string
  default = "dev"

  validation {
    condition     = var.env == "prod"
    error_message = "env must be prod."
  }
}

output "environment" {
  value = var.env
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "env" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "env must be one of: dev, staging, prod."
  }
}

output "environment" {
  value = var.env
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The error shows the validation condition failed for the default value `\"dev\"`.",
            "The condition `var.env == \"prod\"` only passes when the value is exactly `\"prod\"`. The default `\"dev\"` always fails it.",
            "Replace the condition with `contains([\"dev\", \"staging\", \"prod\"], var.env)` to accept all three valid environment names.",
        ],
        "debrief": """\
# The Condition Always Fails

## What Was Broken
The validation condition `var.env == "prod"` only accepts the single value `"prod"`. The default
`"dev"` fails this condition, so every `terraform plan` (without explicitly passing `-var`) fails.

## The Fix
Use `contains()` to check against a list of valid values:

```hcl
validation {
  condition     = contains(["dev", "staging", "prod"], var.env)
  error_message = "env must be one of: dev, staging, prod."
}
```

## Useful Validation Conditions

| Pattern | Example |
|--------|---------|
| Enum check | `contains(["a","b","c"], var.x)` |
| Length check | `length(var.x) >= 3` |
| Regex match | `can(regex("^[a-z]+$", var.x))` |
| Range check | `var.port >= 1024 && var.port <= 65535` |
| Non-empty | `length(var.x) > 0` |

## Why It Matters
A validation condition that rejects the default value is nearly always a bug — it means the module
cannot be used without explicitly overriding the variable every time.
""",
        "common_mistakes": """\
# Common Mistakes

- **Writing a condition that rejects the default value** — always test your condition against the default.
- **Using `==` when multiple values are valid** — use `contains()` for enum-style validation.
- **Overly strict conditions** — consider which environments/values are legitimately valid.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 10 — validation-message
# ─────────────────────────────────────────────────────────────────────────────
def _level_10_validation_message():
    return {
        "module": MODULE,
        "slug": "level-10-validation-message",
        "mission": {
            "name": "An Error Message Must Have Words",
            "description": (
                "A variable has a `validation` block with `error_message = \"\"` — "
                "an empty string. Terraform requires `error_message` to be a non-empty string."
            ),
            "objective": "Add a meaningful `error_message` so `terraform validate` passes.",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["validation", "error_message requirement"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# BUG: error_message cannot be an empty string.

variable "port" {
  type    = number
  default = 8080

  validation {
    condition     = var.port > 0
    error_message = ""
  }
}

output "port" {
  value = var.port
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "port" {
  type    = number
  default = 8080

  validation {
    condition     = var.port > 0
    error_message = "port must be a positive integer greater than 0."
  }
}

output "port" {
  value = var.port
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says `error_message` must not be empty.",
            "The `error_message` is shown to users when their input fails the validation condition. An empty message provides no guidance.",
            "Replace `error_message = \"\"` with a descriptive message like `\"port must be a positive integer greater than 0.\"`",
        ],
        "debrief": """\
# An Error Message Must Have Words

## What Was Broken
`error_message = ""` (empty string) is not allowed. Terraform requires a non-empty, meaningful
error message to help users understand why their value was rejected.

## The Fix
```hcl
validation {
  condition     = var.port > 0
  error_message = "port must be a positive integer greater than 0."
}
```

## Writing Good Error Messages
A good `error_message` should:
1. State what is wrong with the provided value
2. Describe what a valid value looks like
3. Be a complete sentence ending with a period

## Examples

| Condition | Good error_message |
|----------|-------------------|
| `var.port > 0` | `"port must be a positive integer."` |
| `contains(["dev","prod"], var.env)` | `"env must be 'dev' or 'prod'."` |
| `length(var.name) >= 3` | `"name must be at least 3 characters long."` |

## Why It Matters
Error messages are part of your module's user interface. A clear message saves time for everyone
who uses the module — including your future self.
""",
        "common_mistakes": """\
# Common Mistakes

- **Empty `error_message`** — always provide a helpful, non-empty message.
- **Vague messages like `"invalid value"`** — be specific about what is expected.
- **Not ending the message with a period** — Terraform style guide recommends a full sentence with a period.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 11 — nullable-variable
# ─────────────────────────────────────────────────────────────────────────────
def _level_11_nullable_variable():
    return {
        "module": MODULE,
        "slug": "level-11-nullable-variable",
        "mission": {
            "name": "Null and Non-Nullable Don't Mix",
            "description": (
                "A variable has `nullable = false` and `default = null`. This is a contradiction: "
                "`nullable = false` means the variable can never be null, but `default = null` "
                "sets the default to null."
            ),
            "objective": "Fix the contradiction so `terraform validate` passes.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["nullable", "null default contradiction"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# BUG: nullable = false means the variable cannot be null,
# but default = null sets the default to null. Contradiction.

variable "environment" {
  type     = string
  nullable = false
  default  = null
}

output "environment" {
  value = var.environment
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "environment" {
  type     = string
  nullable = false
  default  = "production"
}

output "environment" {
  value = var.environment
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says a non-nullable variable cannot have a `null` default.",
            "`nullable = false` means callers cannot pass `null` as the value. The default must therefore also be non-null.",
            "Change `default = null` to a real string value like `default = \"production\"`.",
        ],
        "debrief": """\
# Null and Non-Nullable Don't Mix

## What Was Broken
`nullable = false` declares that the variable will never have a null value. Setting
`default = null` contradicts this guarantee — if the default is null, the variable starts as null.

## The Fix
```hcl
variable "environment" {
  type     = string
  nullable = false
  default  = "production"
}
```

## The `nullable` Attribute

| Setting           | Meaning |
|------------------|---------|
| `nullable = true` (default) | Variable can be `null`; callers can pass `null` to unset it |
| `nullable = false` | Variable is always non-null; Terraform uses the default when `null` is passed |

## Common Use of `nullable = false`
```hcl
variable "region" {
  type     = string
  nullable = false
  default  = "us-east-1"
}
```

With `nullable = false`, if a caller passes `null` for `region`, Terraform uses `"us-east-1"`
instead of propagating `null`. This is useful for optional-with-sensible-default patterns.

## Why It Matters
The interaction between `nullable`, `default`, and caller-supplied `null` is subtle. Declaring
`nullable = false` with a concrete default is the intended pattern.
""",
        "common_mistakes": """\
# Common Mistakes

- **`nullable = false` with `default = null`** — these are contradictory.
- **Confusing `nullable = false` semantics** — it doesn't prevent the variable from having a default; it prevents the value from ever being null.
- **Omitting `nullable` entirely** — `nullable = true` is the default; add `nullable = false` only when you need the override-null-with-default behavior.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 12 — sensitive-output
# ─────────────────────────────────────────────────────────────────────────────
def _level_12_sensitive_output():
    return {
        "module": MODULE,
        "slug": "level-12-sensitive-output",
        "mission": {
            "name": "Sensitive is a Bool, Not a String",
            "description": (
                "An output block has `sensitive = \"true\"` — a string instead of the boolean `true`. "
                "Terraform's type checker rejects the string."
            ),
            "objective": "Fix `sensitive` to be a boolean so `terraform validate` passes.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["sensitive output", "bool vs string"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "api_key" {
  type      = string
  default   = "super-secret-key"
  sensitive = true
}

# BUG: sensitive = "true" is a string, not a boolean.
output "api_key" {
  value     = var.api_key
  sensitive = "true"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "api_key" {
  type      = string
  default   = "super-secret-key"
  sensitive = true
}

output "api_key" {
  value     = var.api_key
  sensitive = true
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says `sensitive` must be a bool, not a string.",
            "In HCL, `\"true\"` is a string literal. The `sensitive` attribute is a boolean and requires the unquoted `true`.",
            "Change `sensitive = \"true\"` to `sensitive = true` by removing the quotes.",
        ],
        "debrief": """\
# Sensitive is a Bool, Not a String

## What Was Broken
`sensitive = "true"` is a string. The `sensitive` meta-argument of an `output` block is typed as
`bool`, so it requires the unquoted boolean literal `true`.

## The Fix
```hcl
output "api_key" {
  value     = var.api_key
  sensitive = true
}
```

## `output` Meta-Arguments

| Argument      | Type   | Description |
|--------------|--------|-------------|
| `value`       | any    | The value to expose |
| `description` | string | Human-readable description |
| `sensitive`   | bool   | Hide value in plan/apply output |
| `depends_on`  | list   | Explicit dependencies |
| `precondition`| block  | Validate the output value |

## What `sensitive = true` Does
- Masks the value in `terraform plan` and `terraform apply` output (shown as `(sensitive value)`)
- Does **not** encrypt the value in state — it is still stored in plaintext in `terraform.tfstate`
- Prevents the value from being logged in most CI systems

## Why It Matters
The `"true"` vs `true` distinction catches many developers off guard. It is the same class of
error as `"false"` for booleans. Always use unquoted `true`/`false` for boolean attributes.
""",
        "common_mistakes": """\
# Common Mistakes

- **`sensitive = \"true\"` (quoted)** — always use unquoted `true` or `false`.
- **Thinking `sensitive = true` encrypts the state** — it only masks the output; state remains plaintext.
- **Forgetting `sensitive` on outputs that expose secret variables** — if the input is sensitive, the output should be too.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 13 — output-reference
# ─────────────────────────────────────────────────────────────────────────────
def _level_13_output_reference():
    return {
        "module": MODULE,
        "slug": "level-13-output-reference",
        "mission": {
            "name": "Local File Has No Content Output",
            "description": (
                "An output references `local_file.config.content`, but `local_file` does not "
                "expose `content` as a readable exported attribute. Use `.filename` instead."
            ),
            "objective": "Fix the output reference so `terraform validate` passes.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["output values", "resource attributes"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "environment=production"
  filename = "${path.module}/config.txt"
}

# BUG: local_file does not export .content as an attribute.
# Use .filename to get the path of the created file.
output "config_path" {
  value = local_file.config.content
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "environment=production"
  filename = "${path.module}/config.txt"
}

output "config_path" {
  value = local_file.config.filename
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says `local_file.config` has no attribute named `content`.",
            "Although `content` is an *input* argument of `local_file`, it is not exposed as an *exported* attribute you can reference.",
            "Change the reference from `.content` to `.filename` to get the path of the created file.",
        ],
        "debrief": """\
# Local File Has No Content Output

## What Was Broken
`content` is an input argument for `local_file` — you use it to specify what to write. However,
the resource does not re-export `content` as a computed attribute. Terraform rejects the reference.

## The Fix
```hcl
output "config_path" {
  value = local_file.config.filename
}
```

## Input Arguments vs Exported Attributes
A resource's **input arguments** (what you configure) are different from its **exported attributes**
(what you can read back):

| Input argument | Purpose |
|---------------|---------|
| `content`      | Specifies file content to write |
| `filename`     | Specifies the file path |

| Exported attribute | What it contains |
|-------------------|-----------------|
| `filename`         | The file path (same as input) |
| `id`               | SHA1 hash of content |
| `content_md5`      | MD5 hash |
| `content_sha256`   | SHA256 hash |

## Why It Matters
Not all input arguments are readable back as attributes. Check the "Attributes Reference" section
of the provider docs (distinct from "Argument Reference") to see what is exported.
""",
        "common_mistakes": """\
# Common Mistakes

- **Confusing input arguments with exported attributes** — they are listed separately in provider docs.
- **Trying to read back `content`** — use `content_md5` or `content_sha256` if you need to verify the content.
- **Assuming all inputs are also outputs** — this varies by resource and provider.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 14 — output-depends-on
# ─────────────────────────────────────────────────────────────────────────────
def _level_14_output_depends_on():
    return {
        "module": MODULE,
        "slug": "level-14-output-depends-on",
        "mission": {
            "name": "Output Depends on a Ghost",
            "description": (
                "An `output` block has `depends_on = [local_file.nonexistent]`, referencing "
                "a resource that does not exist in the configuration."
            ),
            "objective": "Fix or remove the bogus `depends_on` so `terraform validate` passes.",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["output depends_on"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "app_env=production"
  filename = "${path.module}/config.txt"
}

# BUG: depends_on references a resource that doesn't exist.
output "config_path" {
  value      = local_file.config.filename
  depends_on = [local_file.nonexistent]
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "app_env=production"
  filename = "${path.module}/config.txt"
}

output "config_path" {
  value      = local_file.config.filename
  depends_on = [local_file.config]
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says `local_file.nonexistent` does not exist.",
            "`depends_on` on an output block works the same way as on resource blocks — every reference must point to a real resource.",
            "Change `[local_file.nonexistent]` to `[local_file.config]`, or remove `depends_on` entirely since the value already references `local_file.config` directly.",
        ],
        "debrief": """\
# Output Depends on a Ghost

## What Was Broken
`depends_on = [local_file.nonexistent]` references a resource that doesn't exist. All references
in `depends_on` must resolve to real resources.

## The Fix
```hcl
output "config_path" {
  value      = local_file.config.filename
  depends_on = [local_file.config]
}
```

Or remove `depends_on` entirely — since the output value already references `local_file.config.filename`,
Terraform automatically infers the dependency.

## `depends_on` on Outputs
Output `depends_on` is rarely needed. It is useful when:
- The output value doesn't directly reference a resource, but the output's correctness depends on it
- A side-effect resource must complete before the output is meaningful

```hcl
output "endpoint_url" {
  value      = "https://example.com"
  depends_on = [aws_route53_record.example]  # DNS must exist before URL is useful
}
```

## Why It Matters
The same rules apply to `depends_on` everywhere: all references must resolve to real resources.
A copy-paste error in `depends_on` causes an immediate validate failure.
""",
        "common_mistakes": """\
# Common Mistakes

- **Referencing non-existent resources in output `depends_on`** — same rules as resource `depends_on`.
- **Unnecessarily adding `depends_on` to outputs** — when the value references the resource, the dependency is already implicit.
- **Confusing `depends_on` with `precondition`** — they serve different purposes.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 15 — tfvars-file
# ─────────────────────────────────────────────────────────────────────────────
def _level_15_tfvars_file():
    return {
        "module": MODULE,
        "slug": "level-15-tfvars-file",
        "mission": {
            "name": "The tfvars Assignment Operator",
            "description": (
                "A `terraform.tfvars` file contains `environment \"production\"` — missing the `=` "
                "assignment operator. This is a syntax error that causes `terraform plan` to fail."
            ),
            "objective": "Fix the syntax in `terraform.tfvars` so `terraform plan` succeeds.",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["tfvars syntax"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "environment" {
  type    = string
  default = "dev"
}

output "environment" {
  value = var.environment
}
""",
            "terraform.tfvars": """\
# BUG: Missing = between variable name and value.
environment "production"
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "environment" {
  type    = string
  default = "dev"
}

output "environment" {
  value = var.environment
}
""",
            "terraform.tfvars": """\
environment = "production"
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The error says there is a syntax error in `terraform.tfvars`.",
            "`.tfvars` files use simple `key = value` syntax. Unlike HCL resource blocks, there are no block types — just assignments.",
            "Add the missing `=` between the variable name and its value: `environment = \"production\"`.",
        ],
        "debrief": """\
# The tfvars Assignment Operator

## What Was Broken
`environment "production"` is missing the `=` assignment operator. The `.tfvars` format requires
`key = value` syntax on every line.

## The Fix
```hcl
environment = "production"
```

## `.tfvars` File Format
`.tfvars` files use a simplified subset of HCL:

```hcl
# Simple assignments
region      = "us-east-1"
instance_count = 3
enable_logging = true

# Complex types
tags = {
  owner = "team-a"
  env   = "prod"
}

subnets = ["subnet-abc", "subnet-def"]
```

## How `.tfvars` Files Are Loaded
| Filename pattern       | When loaded |
|-----------------------|-------------|
| `terraform.tfvars`     | Automatically by Terraform |
| `terraform.tfvars.json`| Automatically by Terraform |
| `*.auto.tfvars`        | Automatically by Terraform |
| `custom.tfvars`        | Must pass with `-var-file=custom.tfvars` |

## Why It Matters
`.tfvars` syntax errors are distinct from HCL block syntax errors. The format is simpler but still
requires the `=` operator. Missing it is a common copy-paste or muscle-memory mistake.
""",
        "common_mistakes": """\
# Common Mistakes

- **Missing `=` in tfvars** — every assignment needs `key = value`.
- **Forgetting quotes for string values** — `environment = production` (unquoted) is invalid.
- **Using HCL block syntax in tfvars** — you cannot use `resource`, `variable`, etc. in `.tfvars` files.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 16 — variable-precedence
# ─────────────────────────────────────────────────────────────────────────────
def _level_16_variable_precedence():
    return {
        "module": MODULE,
        "slug": "level-16-variable-precedence",
        "mission": {
            "name": "The Wrong Type Blocks the Flag",
            "description": (
                "A variable `environment` is declared as `type = number` but the intended values "
                "are strings like `\"dev\"` and `\"staging\"`. Running "
                "`terraform plan -var=\"environment=staging\"` fails with a type error."
            ),
            "objective": "Fix the variable type so `terraform plan -var=\"environment=staging\"` succeeds.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["variable precedence", "-var flag"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# BUG: environment should be type = string, not type = number.
# Passing -var="environment=staging" fails because "staging" is not a number.

variable "environment" {
  type    = number
  default = 0
}

output "environment" {
  value = var.environment
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "environment" {
  type    = string
  default = "dev"
}

output "environment" {
  value = var.environment
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

terraform plan -var="environment=staging" -detailed-exitcode -no-color -input=false 2>&1
CODE=$?
if [[ $CODE -eq 0 ]] || [[ $CODE -eq 2 ]]; then
    echo "PASS: terraform plan with -var=environment=staging succeeded"
    exit 0
fi
echo "FAIL: terraform plan -var=environment=staging failed (exit $CODE)"
exit 1
"""),
        "hints": [
            "Run `terraform plan -var=\"environment=staging\"`. The error says `staging` cannot be converted to a number.",
            "The variable is declared as `type = number`, but `staging` is a string. The `-var` flag passes its value according to the declared type.",
            "Change `type = number` to `type = string` and update `default = 0` to `default = \"dev\"`.",
        ],
        "debrief": """\
# The Wrong Type Blocks the Flag

## What Was Broken
The variable `environment` was declared as `type = number`, but the intended values (`"dev"`,
`"staging"`, `"prod"`) are strings. Passing `-var="environment=staging"` fails because `staging`
cannot be converted to a number.

## The Fix
```hcl
variable "environment" {
  type    = string
  default = "dev"
}
```

## Variable Precedence (Lowest to Highest)
1. Default values in variable declarations
2. `terraform.tfvars` file
3. `*.auto.tfvars` files (alphabetical order)
4. `-var-file` flag values
5. `-var` flag values
6. Environment variables (`TF_VAR_<name>`)

Higher-precedence sources override lower ones. The `-var` flag is near the top, making it useful
for one-off overrides in CI/CD pipelines.

## Why It Matters
Variable type declarations affect how all value sources (flags, tfvars, env vars) are interpreted.
Getting the type right is foundational for a module that accepts values from multiple sources.
""",
        "common_mistakes": """\
# Common Mistakes

- **Wrong type declaration blocking string inputs** — use `type = string` for name/environment variables.
- **Forgetting variable precedence order** — `-var` flags override tfvars, which override defaults.
- **Not testing with `-var` flags** — always verify that your module accepts the values callers will pass.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 17 — complex-object-output
# ─────────────────────────────────────────────────────────────────────────────
def _level_17_complex_object_output():
    return {
        "module": MODULE,
        "slug": "level-17-complex-object-output",
        "mission": {
            "name": "Accessing a Key That Doesn't Exist",
            "description": (
                "An output tries to access `var.config.nonexistent_key` on an object variable "
                "that has no such key. The correct key is `name`."
            ),
            "objective": "Fix the output to use the correct key so `terraform plan` succeeds.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["object attribute access", "output values"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "config" {
  type = object({
    name    = string
    version = number
  })
  default = {
    name    = "my-app"
    version = 2
  }
}

# BUG: var.config has no key "nonexistent_key". Use var.config.name instead.
output "app_name" {
  value = var.config.nonexistent_key
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "config" {
  type = object({
    name    = string
    version = number
  })
  default = {
    name    = "my-app"
    version = 2
  }
}

output "app_name" {
  value = var.config.name
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The error says `var.config` has no attribute named `nonexistent_key`.",
            "Look at the `object` type declaration for the `config` variable. The available keys are `name` and `version`.",
            "Change `var.config.nonexistent_key` to `var.config.name`.",
        ],
        "debrief": """\
# Accessing a Key That Doesn't Exist

## What Was Broken
`var.config.nonexistent_key` references an attribute that is not declared in the `object` type.
The valid keys are `name` (string) and `version` (number).

## The Fix
```hcl
output "app_name" {
  value = var.config.name
}
```

## Object Attribute Access Syntax

```hcl
# Given:
variable "config" {
  type = object({ name = string, version = number })
  default = { name = "my-app", version = 2 }
}

# Access individual attributes:
var.config.name      # "my-app"
var.config.version   # 2
```

## Defensive Access with `try()`
If a key might not exist (e.g., with `optional()` keys), use `try()`:

```hcl
output "app_name" {
  value = try(var.config.name, "default-app")
}
```

## Why It Matters
Object attribute access errors are caught at plan time. When working with complex object variables,
always cross-reference the `type` declaration to confirm which keys are available.
""",
        "common_mistakes": """\
# Common Mistakes

- **Typos in attribute names** — use the exact key names from the `object({...})` declaration.
- **Expecting dot-access to work on `map(string)`** — maps use bracket access: `var.tags["key"]` or `var.tags.key`.
- **Not using `try()` for optional keys** — if a key is `optional()`, it may be absent; use `try()` for safe access.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 18 — precondition-output
# ─────────────────────────────────────────────────────────────────────────────
def _level_18_precondition_output():
    return {
        "module": MODULE,
        "slug": "level-18-precondition-output",
        "mission": {
            "name": "Precondition Fails on Its Own Default",
            "description": (
                "An output has a `precondition` block requiring `var.port >= 1024`, "
                "but the variable's default is `80` — which fails the precondition. "
                "`terraform plan` exits with an error."
            ),
            "objective": "Change the variable default to `8080` so `terraform plan` succeeds.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["output precondition"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# BUG: default port is 80, but the precondition requires port >= 1024.
# terraform plan fails when using the default value.

variable "port" {
  type    = number
  default = 80
}

output "service_port" {
  value = var.port

  precondition {
    condition     = var.port >= 1024
    error_message = "port must be >= 1024 (use an unprivileged port)."
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "port" {
  type    = number
  default = 8080
}

output "service_port" {
  value = var.port

  precondition {
    condition     = var.port >= 1024
    error_message = "port must be >= 1024 (use an unprivileged port)."
  }
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The error shows the output precondition failed because `var.port` (80) is less than 1024.",
            "The precondition `var.port >= 1024` is correct — ports below 1024 are privileged and should not be used by application services. The default value is what's wrong.",
            "Change `default = 80` to `default = 8080` (a standard unprivileged application port).",
        ],
        "debrief": """\
# Precondition Fails on Its Own Default

## What Was Broken
The output's precondition requires `var.port >= 1024`. The variable's default is `80`, which
is below 1024 and fails the precondition. `terraform plan` reports the precondition error.

## The Fix
```hcl
variable "port" {
  type    = number
  default = 8080
}
```

## Output `precondition` Block (Terraform >= 1.2)

```hcl
output "service_url" {
  value = "http://example.com:${var.port}"

  precondition {
    condition     = var.port >= 1024
    error_message = "port must be >= 1024 (use an unprivileged port)."
  }
}
```

Preconditions are checked during `terraform plan`. If the condition is false, the plan fails with
the `error_message`.

## `precondition` vs `validation`

| Feature | `variable.validation` | `output.precondition` |
|--------|----------------------|----------------------|
| Where declared | Inside `variable` block | Inside `output` block |
| When checked | Variable assignment | Plan time |
| Can reference other vars | No (only `var.<name>`) | Yes (full expression) |

## Why It Matters
Preconditions on outputs let you express invariants that depend on multiple values — not just a
single variable. A default that violates a precondition is always a bug.
""",
        "common_mistakes": """\
# Common Mistakes

- **Default values that fail their own preconditions** — always test the default against all conditions.
- **Confusing `precondition` with `postcondition`** — `precondition` checks inputs before evaluation; `postcondition` checks the output value after.
- **Using preconditions for simple single-variable checks** — prefer `variable.validation` for those; preconditions shine for cross-variable assertions.
""",
    }


if __name__ == "__main__":
    build()
