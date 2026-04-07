#!/usr/bin/env python3
"""Module 5 — Expressions & Functions (20 levels, Intermediate)."""
from __future__ import annotations

from scripts.build_utils import (
    LOCAL_ONLY_TF,
    print_done,
    validate_custom,
    validate_tf_plan,
    validate_tf_validate,
    write_level,
)

MODULE = "module-5-expressions"


def build() -> int:
    levels = [
        _level_01_format_function(),
        _level_02_formatlist(),
        _level_03_string_functions(),
        _level_04_split_join(),
        _level_05_length_function(),
        _level_06_lookup_function(),
        _level_07_contains_index(),
        _level_08_flatten(),
        _level_09_concat_merge(),
        _level_10_setunion(),
        _level_11_jsonencode(),
        _level_12_templatefile(),
        _level_13_cidrsubnet(),
        _level_14_type_conversion(),
        _level_15_ternary(),
        _level_16_for_expression_list(),
        _level_17_for_expression_map(),
        _level_18_for_expression_filter(),
        _level_19_splat_expression(),
        _level_20_string_directive(),
    ]
    for lvl in levels:
        write_level(lvl)
    print_done(MODULE, len(levels))
    return len(levels)


# ─────────────────────────────────────────────────────────────────────────────
# Level 1 — format-function
# ─────────────────────────────────────────────────────────────────────────────
def _level_01_format_function():
    broken_main = """\
# BUG: format() is called with only one argument but the format string
# has two placeholders (%s and %d).

locals {
  app_label = format("%s-%d", "app")
}

output "app_label" {
  value = local.app_label
}
"""
    solution_main = """\
locals {
  app_label = format("%s-%d", "app", 1)
}

output "app_label" {
  value = local.app_label
}
"""
    return {
        "module": MODULE,
        "slug": "level-1-format-function",
        "mission": {
            "name": "Format Function",
            "description": "`format(\"%s-%d\", \"app\")` is called with only one argument but the format string expects two values — one `%s` (string) and one `%d` (integer).",
            "objective": "Add the missing second argument so the call becomes `format(\"%s-%d\", \"app\", 1)` and `terraform plan` succeeds.",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "8m",
            "concepts": ["format()", "format specifiers"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform validate` — it reports that `format` received the wrong number of arguments for the given format string.",
            "`%s` expects a string argument and `%d` expects an integer argument. Count the placeholders in the format string.",
            "Add `1` as the second argument: `format(\"%s-%d\", \"app\", 1)`.",
        ],
        "debrief": """\
# Format Function

## What Was Broken
`format("%s-%d", "app")` provided only one value for two placeholders. Each placeholder in the
format string must have a corresponding argument.

## The Fix
```hcl
locals {
  app_label = format("%s-%d", "app", 1)
}
```

## format() Specifiers
| Specifier | Type    | Example            |
|-----------|---------|-------------------|
| `%s`      | string  | `format("%s", "hello")` → `"hello"` |
| `%d`      | integer | `format("%d", 42)` → `"42"` |
| `%f`      | float   | `format("%.2f", 3.14)` → `"3.14"` |
| `%v`      | any     | generic value representation |
| `%%`      | literal | produces a `%` character |

## Why It Matters
`format()` is the Terraform equivalent of printf-style formatting. Mismatched argument counts
cause runtime errors that only surface when the expression is evaluated.
""",
        "common_mistakes": """\
# Common Mistakes

- **Too few arguments** — every placeholder needs a corresponding argument.
- **Type mismatch** — passing a string to `%d` or a number to `%s` causes type errors.
- **Using `%v` as a shortcut** — it works but gives less control over output formatting.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 2 — formatlist
# ─────────────────────────────────────────────────────────────────────────────
def _level_02_formatlist():
    broken_main = """\
# BUG: formatlist with two placeholders but only one list argument.
# formatlist requires a list for each placeholder.

locals {
  labels = formatlist("%s-%s", ["a", "b"])
}

output "labels" {
  value = local.labels
}
"""
    solution_main = """\
locals {
  labels = formatlist("%s", ["a", "b"])
}

output "labels" {
  value = local.labels
}
"""
    return {
        "module": MODULE,
        "slug": "level-2-formatlist",
        "mission": {
            "name": "Format List",
            "description": "`formatlist(\"%s-%s\", [\"a\",\"b\"])` has two `%s` placeholders but only one list argument. `formatlist` requires a list for each placeholder.",
            "objective": "Fix the call to use a single placeholder: `formatlist(\"%s\", [\"a\",\"b\"])` so the output is `[\"a\", \"b\"]`.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["formatlist()"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform validate` — the error reports a mismatch between the number of format placeholders and list arguments.",
            "`formatlist` maps over lists: each placeholder needs its own list. `formatlist(\"%s-%s\", [\"a\",\"b\"], [\"x\",\"y\"])` would produce `[\"a-x\", \"b-y\"]`.",
            "The simplest fix is to reduce to one placeholder: `formatlist(\"%s\", [\"a\",\"b\"])`.",
        ],
        "debrief": """\
# Format List

## What Was Broken
`formatlist("%s-%s", ["a","b"])` provided two placeholders but only one list. Each `%s` needs
its own list argument — or you use a single list with one placeholder.

## The Fix
```hcl
locals {
  labels = formatlist("%s", ["a", "b"])
  # Produces: ["a", "b"]
}
```

## formatlist() vs format()
- `format()` produces a single string
- `formatlist()` maps a format string over one or more lists, producing a list of strings

```hcl
formatlist("%s-%d", ["web", "api"], [1, 2])
# → ["web-1", "api-2"]
```

## Why It Matters
`formatlist()` is useful for generating resource names, tags, or labels in bulk from lists of
values — a common pattern when combined with `for_each`.
""",
        "common_mistakes": """\
# Common Mistakes

- **Placeholder/list count mismatch** — every placeholder needs a corresponding list.
- **Lists of different lengths** — all list arguments to `formatlist` must have the same length.
- **Using `format()` when you want a list** — `format()` always returns a single string.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 3 — string-functions
# ─────────────────────────────────────────────────────────────────────────────
def _level_03_string_functions():
    broken_main = """\
variable "name" {
  type    = string
  default = "Hello World 123"
}

locals {
  # BUG: replace() takes exactly 3 arguments, not 4
  cleaned = replace(var.name, "/[^a-z]/", "-", "g")
}

output "cleaned" {
  value = local.cleaned
}
"""
    solution_main = """\
variable "name" {
  type    = string
  default = "Hello World 123"
}

locals {
  cleaned = replace(var.name, "/[^a-z]/", "-")
}

output "cleaned" {
  value = local.cleaned
}
"""
    return {
        "module": MODULE,
        "slug": "level-3-string-functions",
        "mission": {
            "name": "String Functions",
            "description": "`replace(var.name, \"/[^a-z]/\", \"-\", \"g\")` is called with 4 arguments, but `replace()` only accepts 3. The trailing `\"g\"` flag is not a valid parameter.",
            "objective": "Remove the extra `\"g\"` argument so the call is `replace(var.name, \"/[^a-z]/\", \"-\")` and `terraform validate` passes.",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "8m",
            "concepts": ["replace()", "string functions"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate` — it reports that `replace` was called with too many arguments.",
            "Terraform's `replace(string, search, replace)` always replaces all occurrences. There is no flag argument.",
            "Remove the fourth argument `\"g\"` from the call.",
        ],
        "debrief": """\
# String Functions

## What Was Broken
`replace()` was called with 4 arguments. The function signature is:
```
replace(string, search, replacement)
```
The `"g"` flag (global replace) is a concept from some regex flavors but is not a Terraform
`replace()` parameter — Terraform always replaces all matches globally.

## The Fix
```hcl
locals {
  cleaned = replace(var.name, "/[^a-z]/", "-")
}
```

## replace() Signatures
```hcl
replace("hello world", "world", "terraform")   # → "hello terraform"
replace("Hello123", "/[^a-z]/", "-")           # → "--ello---"  (regex replace)
```

When `search` is wrapped in `/…/`, it's treated as a regular expression.

## Why It Matters
String manipulation functions are used constantly for generating resource names, sanitizing
inputs, and building dynamic values. Knowing the exact signatures prevents subtle errors.
""",
        "common_mistakes": """\
# Common Mistakes

- **Adding a global flag** — Terraform's `replace()` always replaces all matches; no flag needed.
- **Forgetting regex delimiters** — regex patterns must be wrapped in `/…/` to be treated as regex.
- **Confusing `replace()` with `regexreplace()`** — both work with regex; `regexreplace` is an alias.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 4 — split-join
# ─────────────────────────────────────────────────────────────────────────────
def _level_04_split_join():
    broken_main = """\
locals {
  # BUG: the string uses semicolons but split uses a comma separator
  raw   = "a;b;c"
  parts = split(",", local.raw)
  rejoined = join("-", local.parts)
}

output "result" {
  value = local.rejoined
}
"""
    solution_main = """\
locals {
  raw      = "a;b;c"
  parts    = split(";", local.raw)
  rejoined = join("-", local.parts)
}

output "result" {
  value = local.rejoined
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

terraform plan -detailed-exitcode -no-color -input=false > /tmp/plan_out.txt 2>&1
PLAN_EXIT=$?
if [[ $PLAN_EXIT -ne 0 ]] && [[ $PLAN_EXIT -ne 2 ]]; then
    cat /tmp/plan_out.txt
    echo "❌ FAIL: terraform plan failed (exit $PLAN_EXIT)"
    exit 1
fi

if ! terraform apply -auto-approve -no-color -input=false > /tmp/apply_out.txt 2>&1; then
    cat /tmp/apply_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

ACTUAL=$(terraform output -raw result 2>/dev/null || echo "__MISSING__")
EXPECTED="a-b-c"
if [[ "$ACTUAL" == "$EXPECTED" ]]; then
    echo "✅ PASS: output 'result' = '$ACTUAL'"
    exit 0
fi
echo "❌ FAIL: expected '$EXPECTED', got '$ACTUAL'"
exit 1
""")
    return {
        "module": MODULE,
        "slug": "level-4-split-join",
        "mission": {
            "name": "Split and Join",
            "description": "The string `\"a;b;c\"` uses semicolons as separators, but `split(\",\", ...)` uses a comma. The split returns the whole string as one element instead of three.",
            "objective": "Fix the separator in `split()` from `\",\"` to `\";\"` so the output `result` equals `\"a-b-c\"`.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["split()", "join()"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate,
        "hints": [
            "Run `terraform apply` and check the `result` output — it will be `\"a;b;c\"` (the whole string) instead of `\"a-b-c\"`.",
            "The string uses semicolons (`;`) but `split()` is looking for commas (`,`). They don't match, so no split happens.",
            "Change `split(\",\", local.raw)` to `split(\";\", local.raw)`.",
        ],
        "debrief": """\
# Split and Join

## What Was Broken
`split(",", "a;b;c")` looked for commas in a string that uses semicolons. Since no commas were
found, the entire string was returned as a one-element list: `["a;b;c"]`.

## The Fix
```hcl
parts    = split(";", local.raw)     # ["a", "b", "c"]
rejoined = join("-", local.parts)    # "a-b-c"
```

## split() and join()
```hcl
split(",", "a,b,c")       # → ["a", "b", "c"]
join("-", ["a", "b", "c"]) # → "a-b-c"
join("", ["a", "b", "c"])  # → "abc"
```

`split` and `join` are inverses: `join(sep, split(sep, s)) == s`

## Why It Matters
Split/join operations are common when processing tag values, environment variables, or
CSV-style configuration strings. A wrong separator is a silent bug — no error, just wrong output.
""",
        "common_mistakes": """\
# Common Mistakes

- **Separator mismatch** — the separator in `split()` must match the actual delimiter in the string.
- **Assuming trim** — `split` does not trim whitespace from elements; use `trimspace()` if needed.
- **Using split on empty string** — `split(",", "")` returns `[""]` (a list with one empty string), not `[]`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 5 — length-function
# ─────────────────────────────────────────────────────────────────────────────
def _level_05_length_function():
    broken_main = """\
variable "items" {
  type = map(string)
  default = {
    a = "apple"
    b = "banana"
    c = "cherry"
  }
}

# BUG: var.items.nonexistent is not a valid reference — maps use lookup() or []
resource "local_file" "output" {
  count    = length(var.items.nonexistent)
  content  = "item ${count.index}"
  filename = "${path.module}/item-${count.index}.txt"
}
"""
    solution_main = """\
variable "items" {
  type = map(string)
  default = {
    a = "apple"
    b = "banana"
    c = "cherry"
  }
}

resource "local_file" "output" {
  count    = length(var.items)
  content  = "item ${count.index}"
  filename = "${path.module}/item-${count.index}.txt"
}
"""
    return {
        "module": MODULE,
        "slug": "level-5-length-function",
        "mission": {
            "name": "Length Function",
            "description": "`length(var.items.nonexistent)` tries to access a key `nonexistent` on the map before calling `length()`. This fails because the key doesn't exist.",
            "objective": "Fix the count expression to use `length(var.items)` — the length of the whole map — so `terraform plan` succeeds.",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "8m",
            "concepts": ["length()"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform validate` — it reports that `var.items` has no attribute `nonexistent`.",
            "`length()` can be called directly on a map: `length(var.items)` returns the number of keys.",
            "Change `length(var.items.nonexistent)` to `length(var.items)`.",
        ],
        "debrief": """\
# Length Function

## What Was Broken
`var.items.nonexistent` tried to access a key called `nonexistent` on the map variable, which
doesn't exist. The fix is to call `length()` on the map itself.

## The Fix
```hcl
count = length(var.items)   # returns 3 for a map with 3 keys
```

## length() Behavior
```hcl
length("hello")          # → 5  (string length in characters)
length(["a", "b", "c"])  # → 3  (list length)
length({a=1, b=2})       # → 2  (map key count)
```

## Why It Matters
`length()` is one of the most-used Terraform functions. Knowing it works on strings, lists,
and maps avoids the need to extract keys separately before counting.
""",
        "common_mistakes": """\
# Common Mistakes

- **Accessing nonexistent map keys** — use `lookup(map, key, default)` for safe access.
- **length() on null** — calling `length(null)` causes an error; use `var != null ? length(var) : 0`.
- **Counting map values vs keys** — `length(map)` counts keys; to count values, use `length(values(map))`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 6 — lookup-function
# ─────────────────────────────────────────────────────────────────────────────
def _level_06_lookup_function():
    broken_main = """\
variable "config" {
  type = map(string)
  default = {
    host = "localhost"
  }
}

# BUG: lookup() requires a default value as the third argument
locals {
  port = lookup(var.config, "port")
}

output "port" {
  value = local.port
}
"""
    solution_main = """\
variable "config" {
  type = map(string)
  default = {
    host = "localhost"
  }
}

locals {
  port = lookup(var.config, "port", 8080)
}

output "port" {
  value = local.port
}
"""
    return {
        "module": MODULE,
        "slug": "level-6-lookup-function",
        "mission": {
            "name": "Lookup Function",
            "description": "`lookup(var.config, \"port\")` is called with only 2 arguments. The `lookup()` function requires a third argument: the default value to return if the key is not found.",
            "objective": "Add a default value: `lookup(var.config, \"port\", 8080)` so `terraform validate` passes.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["lookup()"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate` — it reports that `lookup` requires 3 arguments.",
            "`lookup(map, key, default)` returns the value for `key` if it exists, otherwise returns `default`.",
            "Add `8080` (or any sensible default) as the third argument: `lookup(var.config, \"port\", 8080)`.",
        ],
        "debrief": """\
# Lookup Function

## What Was Broken
`lookup()` requires exactly 3 arguments: the map, the key, and the default value.
Calling it with 2 arguments is a validation error.

## The Fix
```hcl
locals {
  port = lookup(var.config, "port", 8080)
}
```

## lookup() vs Direct Access
```hcl
# Direct access — errors if key doesn't exist
var.config["port"]

# lookup with default — safe, returns default if key missing
lookup(var.config, "port", 8080)

# can also be written as:
try(var.config["port"], 8080)
```

## Why It Matters
`lookup()` provides safe map access with a fallback, which is essential when working with
optional configuration maps where not all keys are guaranteed to be present.
""",
        "common_mistakes": """\
# Common Mistakes

- **Missing default argument** — `lookup` always requires a default.
- **Direct map access on optional keys** — `map["key"]` errors if the key is absent; prefer `lookup`.
- **Wrong default type** — the default must be the same type as the map values.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 7 — contains-index
# ─────────────────────────────────────────────────────────────────────────────
def _level_07_contains_index():
    broken_main = """\
locals {
  allowed = ["a", "b", "c"]

  # BUG: index() errors if the value is not found in the list
  # "d" is not in the list, so this will fail at plan time
  position = index(local.allowed, "d")
}

output "position" {
  value = local.position
}
"""
    solution_main = """\
locals {
  allowed  = ["a", "b", "c"]
  is_valid = contains(local.allowed, "d")
}

output "is_valid" {
  value = local.is_valid
}
"""
    return {
        "module": MODULE,
        "slug": "level-7-contains-index",
        "mission": {
            "name": "Contains vs Index",
            "description": "`index([\"a\",\"b\",\"c\"], \"d\")` tries to find `\"d\"` in the list, but `\"d\"` is not present. `index()` throws an error when the value is not found.",
            "objective": "Replace the `index()` call with `contains()` which safely returns `false` when the value is absent. Update the local and output names accordingly.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["contains()", "index()"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan` — it errors because `index()` cannot find `\"d\"` in the list.",
            "`contains(list, value)` returns `true` or `false` and never errors. Use it for membership checks.",
            "Replace `index(local.allowed, \"d\")` with `contains(local.allowed, \"d\")` and update the output.",
        ],
        "debrief": """\
# Contains vs Index

## What Was Broken
`index(list, value)` returns the zero-based position of `value` in `list`, but **errors** if
the value is not present. Since `"d"` is not in `["a","b","c"]`, this always fails.

## The Fix
```hcl
locals {
  is_valid = contains(local.allowed, "d")   # → false, no error
}
```

## index() vs contains()
| Function     | Found     | Not Found    |
|-------------|-----------|--------------|
| `index()`   | returns position | **errors** |
| `contains()` | returns `true` | returns `false` |

Use `index()` only when you're certain the value exists. Use `contains()` for validation checks.

## Why It Matters
Membership checks are common in validation logic, conditional resources, and input sanitization.
Using `index()` for existence checks is a silent bug waiting to cause a runtime failure.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `index()` as a membership check** — prefer `contains()` for safety.
- **0-based vs 1-based confusion** — `index()` returns 0 for the first element, not 1.
- **Using `contains()` on maps** — `contains()` only works on lists/sets; use `lookup()` for maps.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 8 — flatten
# ─────────────────────────────────────────────────────────────────────────────
def _level_08_flatten():
    broken_main = """\
locals {
  # BUG: flatten expects all elements to be lists (or scalars that become single-element lists),
  # but "c" is a bare string, not a list. This causes a type error.
  items = flatten([["a", "b"], "c"])
}

output "items" {
  value = local.items
}
"""
    solution_main = """\
locals {
  items = flatten([["a", "b"], ["c"]])
}

output "items" {
  value = local.items
}
"""
    return {
        "module": MODULE,
        "slug": "level-8-flatten",
        "mission": {
            "name": "Flatten",
            "description": "`flatten([[\"a\",\"b\"], \"c\"])` mixes a list and a bare string at the top level. `flatten()` expects all top-level elements to be lists.",
            "objective": "Wrap `\"c\"` in a list: `flatten([[\"a\",\"b\"], [\"c\"]])` so the output is `[\"a\", \"b\", \"c\"]`.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["flatten()"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform validate` — it reports a type error because `flatten` cannot mix lists and strings at the top level.",
            "`flatten()` takes a list of lists and returns a single flat list. Every top-level element must be a list.",
            "Change `\"c\"` to `[\"c\"]` to make it a single-element list.",
        ],
        "debrief": """\
# Flatten

## What Was Broken
`flatten([["a","b"], "c"])` mixed a list `["a","b"]` with a bare string `"c"`. `flatten()`
requires all top-level elements to be lists (they can be nested arbitrarily deep).

## The Fix
```hcl
locals {
  items = flatten([["a", "b"], ["c"]])
  # → ["a", "b", "c"]
}
```

## flatten() Behavior
```hcl
flatten([[1, 2], [3, 4]])        # → [1, 2, 3, 4]
flatten([[1, [2, 3]], [4]])      # → [1, 2, 3, 4]  (recursive)
flatten([["a"], [], ["b","c"]])  # → ["a", "b", "c"]
```

## Common Pattern with for_each
```hcl
locals {
  all_rules = flatten([
    for group in var.security_groups : group.rules
  ])
}
```

## Why It Matters
`flatten()` combined with `for` expressions is a fundamental pattern for transforming
nested data structures into flat lists suitable for `for_each`.
""",
        "common_mistakes": """\
# Common Mistakes

- **Mixing scalars and lists** — wrap bare values in `[...]` before passing to `flatten`.
- **Expecting flatten to work on maps** — `flatten` only works on lists and tuples.
- **Unnecessary flatten** — if your data is already flat, `flatten` is a no-op but causes confusion.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 9 — concat-merge
# ─────────────────────────────────────────────────────────────────────────────
def _level_09_concat_merge():
    broken_main = """\
locals {
  # BUG: merge() is for maps, not lists
  combined = merge(["a", "b"], ["c"])
}

output "combined" {
  value = local.combined
}
"""
    solution_main = """\
locals {
  combined = concat(["a", "b"], ["c"])
}

output "combined" {
  value = local.combined
}
"""
    return {
        "module": MODULE,
        "slug": "level-9-concat-merge",
        "mission": {
            "name": "Concat vs Merge",
            "description": "`merge([\"a\",\"b\"], [\"c\"])` uses `merge()` on lists, but `merge()` is designed for maps. Use `concat()` to combine lists.",
            "objective": "Replace `merge(...)` with `concat([\"a\",\"b\"], [\"c\"])` so `terraform validate` passes.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["concat()", "merge()"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate` — `merge()` does not accept lists.",
            "`merge()` combines maps: `merge({a=1}, {b=2})` → `{a=1, b=2}`. For lists, use `concat()`.",
            "Change `merge(...)` to `concat([\"a\",\"b\"], [\"c\"])`.",
        ],
        "debrief": """\
# Concat vs Merge

## What Was Broken
`merge()` was called on lists. It only accepts maps/objects. Lists are combined with `concat()`.

## The Fix
```hcl
locals {
  combined = concat(["a", "b"], ["c"])
  # → ["a", "b", "c"]
}
```

## concat() vs merge()
| Function   | Input types | Purpose                          |
|-----------|-------------|----------------------------------|
| `concat()` | lists/tuples | Combine multiple lists into one  |
| `merge()`  | maps/objects | Merge maps (later keys win)       |

```hcl
concat(["a"], ["b", "c"])      # → ["a", "b", "c"]
merge({x=1}, {y=2, x=99})     # → {x=99, y=2}  (second x wins)
```

## Why It Matters
Choosing the wrong combination function is a type error caught at validate time. Understanding
the type model — lists vs maps — is fundamental to writing correct Terraform expressions.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `merge()` on lists** — `merge` is maps-only; use `concat` for lists.
- **Using `concat()` on maps** — `concat` is lists-only; use `merge` for maps.
- **Key collision in merge** — when maps share keys, the rightmost map wins.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 10 — setunion
# ─────────────────────────────────────────────────────────────────────────────
def _level_10_setunion():
    broken_main = """\
locals {
  # BUG: setunion expects sets, not lists — pass toset() to convert first
  combined = setunion(["a", "b"], ["c"])
}

output "combined" {
  value = local.combined
}
"""
    solution_main = """\
locals {
  combined = setunion(toset(["a", "b"]), toset(["c"]))
}

output "combined" {
  value = local.combined
}
"""
    return {
        "module": MODULE,
        "slug": "level-10-setunion",
        "mission": {
            "name": "Set Union",
            "description": "`setunion([\"a\",\"b\"], [\"c\"])` passes lists to `setunion()`, but it expects sets. Convert the lists with `toset()` first.",
            "objective": "Wrap both arguments with `toset()`: `setunion(toset([\"a\",\"b\"]), toset([\"c\"]))` so `terraform plan` succeeds.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["setunion()", "toset()"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform validate` — `setunion` requires set arguments, not lists.",
            "`toset(list)` converts a list to a set (removing duplicates and dropping order).",
            "Wrap each list argument: `setunion(toset([\"a\",\"b\"]), toset([\"c\"]))`.",
        ],
        "debrief": """\
# Set Union

## What Was Broken
`setunion()` requires set arguments. Lists and sets are distinct types in Terraform. The
`toset()` function converts a list to a set.

## The Fix
```hcl
locals {
  combined = setunion(toset(["a", "b"]), toset(["c"]))
  # → toset(["a", "b", "c"])
}
```

## Set Functions
```hcl
setunion(toset([1,2]), toset([2,3]))         # → {1, 2, 3}
setintersection(toset([1,2]), toset([2,3]))  # → {2}
setsubtract(toset([1,2,3]), toset([2]))      # → {1, 3}
```

## Sets vs Lists
- Sets have no defined order
- Sets cannot contain duplicate elements
- Use `tolist(set)` to convert back to a list (order is undefined)

## Why It Matters
Set operations are essential for computing permissions, security group rules, and other
"union of requirements" patterns that appear in infrastructure-as-code.
""",
        "common_mistakes": """\
# Common Mistakes

- **Passing lists to set functions** — always use `toset()` to convert first.
- **Assuming set order** — sets are unordered; don't rely on element position.
- **Duplicate removal** — `toset(["a","a","b"])` silently removes the duplicate; be aware.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 11 — jsonencode
# ─────────────────────────────────────────────────────────────────────────────
def _level_11_jsonencode():
    broken_main = """\
locals {
  # BUG: timestamp() produces a dynamic value that cannot be serialised
  # consistently at plan time and may cause issues with jsonencode in some contexts.
  # Replace with a static map.
  config = {
    name      = "app"
    generated = timestamp()
  }
  config_json = jsonencode(local.config)
}

output "config_json" {
  value = local.config_json
}
"""
    solution_main = """\
locals {
  config = {
    name    = "app"
    version = "1.0.0"
  }
  config_json = jsonencode(local.config)
}

output "config_json" {
  value = local.config_json
}
"""
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

terraform plan -detailed-exitcode -no-color -input=false > /tmp/plan_out.txt 2>&1
PLAN_EXIT=$?
if [[ $PLAN_EXIT -ne 0 ]] && [[ $PLAN_EXIT -ne 2 ]]; then
    cat /tmp/plan_out.txt
    echo "❌ FAIL: terraform plan failed"
    exit 1
fi

if ! terraform apply -auto-approve -no-color -input=false > /tmp/apply_out.txt 2>&1; then
    cat /tmp/apply_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

OUT=$(terraform output -raw config_json 2>/dev/null || echo "")
if python3 -c "import json, sys; json.loads(sys.argv[1])" "$OUT" 2>/dev/null; then
    echo "✅ PASS: config_json is valid JSON"
    exit 0
fi
echo "❌ FAIL: config_json is not valid JSON or missing"
exit 1
""")
    return {
        "module": MODULE,
        "slug": "level-11-jsonencode",
        "mission": {
            "name": "JSON Encode",
            "description": "The `local.config` map uses `timestamp()` which produces a dynamic, non-deterministic value. This causes plan instability — the JSON output changes on every run. Replace it with a static map.",
            "objective": "Remove `timestamp()` and replace it with a static string value so `jsonencode(local.config)` produces stable, valid JSON.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["jsonencode()", "serialization", "plan stability"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate,
        "hints": [
            "Run `terraform plan` twice and observe whether the output value changes — `timestamp()` returns the current time, making the plan non-idempotent.",
            "`timestamp()` is useful in triggers or `local-exec`, but not in stable configuration values that get serialized.",
            "Replace `generated = timestamp()` with a static value like `version = \"1.0.0\"`.",
        ],
        "debrief": """\
# JSON Encode

## What Was Broken
`timestamp()` returns the current UTC time as a string. Every plan run produces a different value,
making the JSON non-deterministic. This causes permanent drift: every plan shows a change.

## The Fix
```hcl
locals {
  config = {
    name    = "app"
    version = "1.0.0"
  }
  config_json = jsonencode(local.config)
}
```

## jsonencode() Usage
```hcl
jsonencode({name = "app", port = 8080})
# → "{\"name\":\"app\",\"port\":8080}"

jsonencode(["a", "b", "c"])
# → "[\"a\",\"b\",\"c\"]"
```

## Why It Matters
Plan stability is critical for CI/CD pipelines. Non-deterministic values (timestamps, random
IDs) in config cause permanent "changes detected" that mask real infrastructure drift.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `timestamp()` in stable config** — reserve it for triggers or one-time stamps.
- **Assuming jsonencode always produces the same key order** — JSON object key order is not guaranteed.
- **Encoding sensitive values** — `jsonencode` does not redact sensitive values; use `sensitive()` wrapper if needed.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 12 — templatefile
# ─────────────────────────────────────────────────────────────────────────────
def _level_12_templatefile():
    broken_main = """\
variable "app" {
  type    = string
  default = "myapp"
}

# BUG: the vars map uses key "name" but the template expects "${app_name}"
resource "local_file" "rendered" {
  content  = templatefile("${path.module}/app.tpl", { name = var.app })
  filename = "${path.module}/rendered.txt"
}
"""
    broken_tpl = """\
Application: ${app_name}
Environment: production
"""
    solution_main = """\
variable "app" {
  type    = string
  default = "myapp"
}

resource "local_file" "rendered" {
  content  = templatefile("${path.module}/app.tpl", { app_name = var.app })
  filename = "${path.module}/rendered.txt"
}
"""
    solution_tpl = broken_tpl  # template is correct; fix is in main.tf vars map
    validate = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/apply_out.txt 2>&1; then
    cat /tmp/apply_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

RENDERED=$(find . -name "rendered.txt" 2>/dev/null | head -1)
if [[ -z "$RENDERED" ]]; then
    echo "❌ FAIL: rendered.txt not found"
    exit 1
fi

if grep -q "myapp" "$RENDERED" 2>/dev/null; then
    echo "✅ PASS: rendered.txt contains the app name"
    exit 0
fi
echo "❌ FAIL: rendered.txt does not contain the app name — template variable mismatch?"
cat "$RENDERED" 2>/dev/null || true
exit 1
""")
    return {
        "module": MODULE,
        "slug": "level-12-templatefile",
        "mission": {
            "name": "Template File",
            "description": "`templatefile()` is called with `{ name = var.app }` but the template `app.tpl` uses `${app_name}`. The variable name in the map doesn't match the placeholder in the template.",
            "objective": "Change the vars map key from `name` to `app_name` so the template renders correctly and the output file contains `\"myapp\"`.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["templatefile()", "variable names", "template rendering"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": broken_main,
            "app.tpl": broken_tpl,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": solution_main,
            "app.tpl": solution_tpl,
        },
        "validate": validate,
        "hints": [
            "Run `terraform plan` — it fails because the template references `${app_name}` but the vars map only has a key `name`.",
            "Open `app.tpl` and check the placeholder name. It uses `${app_name}`, not `${name}`.",
            "In `main.tf`, change `{ name = var.app }` to `{ app_name = var.app }` in the `templatefile()` call.",
        ],
        "debrief": """\
# Template File

## What Was Broken
The template file used `${app_name}` but the vars map passed `{ name = var.app }`. The key
`name` ≠ `app_name`, so Terraform could not resolve the placeholder.

## The Fix
```hcl
content = templatefile("${path.module}/app.tpl", { app_name = var.app })
```

## templatefile() Syntax
```hcl
templatefile("<path>", <vars_map>)
```

Template placeholders use `${variable_name}` syntax, and every placeholder in the template
must have a corresponding key in the vars map.

Template directives:
```
%{ if condition }...%{ endif }
%{ for x in list }${x}%{ endfor }
```

## Why It Matters
Template rendering errors only surface at apply time, not at validate time. Always verify that
template variable names exactly match the keys in the vars map.
""",
        "common_mistakes": """\
# Common Mistakes

- **Key name mismatch** — template placeholder names must exactly match the vars map keys.
- **Missing template file** — the `.tpl` path must exist at plan/apply time.
- **Using HCL syntax in templates** — templates use `${var}` syntax, not `local.x` or `var.x`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 13 — cidrsubnet
# ─────────────────────────────────────────────────────────────────────────────
def _level_13_cidrsubnet():
    broken_main = """\
# BUG: cidrsubnet("10.0.0.0/24", 8, 1) tries to add 8 bits to a /24,
# producing a /32, and then index 1 overflows the available addresses.

locals {
  subnet = cidrsubnet("10.0.0.0/24", 8, 1)
}

output "subnet" {
  value = local.subnet
}
"""
    solution_main = """\
locals {
  subnet = cidrsubnet("10.0.0.0/16", 8, 1)
}

output "subnet" {
  value = local.subnet
}
"""
    return {
        "module": MODULE,
        "slug": "level-13-cidrsubnet",
        "mission": {
            "name": "CIDR Subnet",
            "description": "`cidrsubnet(\"10.0.0.0/24\", 8, 1)` tries to add 8 bits to a /24 network, creating a /32. A /32 is a single host address — subnet index 1 overflows.",
            "objective": "Change the base to `\"10.0.0.0/16\"` so there is room to add 8 bits (creating /24 subnets) and index 1 is valid.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["cidrsubnet()", "CIDR math"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan` — it reports an error about the subnet index being out of range.",
            "`cidrsubnet(prefix, newbits, netnum)` adds `newbits` to the prefix length. `/24 + 8 = /32` — a single host, leaving no room for subnets.",
            "Change the base CIDR to `\"10.0.0.0/16\"` so `/16 + 8 = /24`, giving 256 possible subnets.",
        ],
        "debrief": """\
# CIDR Subnet

## What Was Broken
`cidrsubnet("10.0.0.0/24", 8, 1)`:
- Base: `/24` (256 addresses)
- Add 8 bits: `/24 + 8 = /32` (a single address)
- A `/32` has only 1 address (index 0), so index 1 overflows

## The Fix
```hcl
locals {
  subnet = cidrsubnet("10.0.0.0/16", 8, 1)
  # Base /16 + 8 bits = /24 subnet
  # Index 1 → "10.0.1.0/24"
}
```

## cidrsubnet() Math
```
cidrsubnet(prefix, newbits, netnum)
```
- `prefix` — the base CIDR block (e.g., `"10.0.0.0/16"`)
- `newbits` — number of additional bits for the subnet mask
- `netnum` — zero-based subnet index

```hcl
cidrsubnet("10.0.0.0/16", 8, 0)  # → "10.0.0.0/24"
cidrsubnet("10.0.0.0/16", 8, 1)  # → "10.0.1.0/24"
cidrsubnet("10.0.0.0/16", 8, 255) # → "10.0.255.0/24"
```

## Why It Matters
CIDR math errors are easy to make and can lead to overlapping subnets, routing problems,
or silent failures at apply time when the cloud provider rejects the address range.
""",
        "common_mistakes": """\
# Common Mistakes

- **Base CIDR too narrow** — adding bits to a `/24` quickly runs out of address space.
- **Off-by-one in netnum** — subnets are 0-indexed; the maximum index is `2^newbits - 1`.
- **Overlapping CIDRs** — when generating multiple subnets, use consecutive netnum values.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 14 — type-conversion
# ─────────────────────────────────────────────────────────────────────────────
def _level_14_type_conversion():
    broken_main = """\
variable "my_map" {
  type = map(string)
  default = {
    a = "apple"
    b = "banana"
  }
}

# BUG: tolist() cannot convert a map to a list
locals {
  as_list = tolist(var.my_map)
}

output "as_list" {
  value = local.as_list
}
"""
    solution_main = """\
variable "my_map" {
  type = map(string)
  default = {
    a = "apple"
    b = "banana"
  }
}

locals {
  as_list = values(var.my_map)
}

output "as_list" {
  value = local.as_list
}
"""
    return {
        "module": MODULE,
        "slug": "level-14-type-conversion",
        "mission": {
            "name": "Type Conversion",
            "description": "`tolist(var.my_map)` tries to convert a `map(string)` to a list, but `tolist()` only works on collections that are already list-like (tuples). Maps must use `values()` to extract their values as a list.",
            "objective": "Replace `tolist(var.my_map)` with `values(var.my_map)` so `terraform validate` passes.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["tolist()", "type conversion", "values()"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate` — `tolist()` cannot convert a map type.",
            "`values(map)` returns a list of a map's values. `keys(map)` returns a list of its keys.",
            "Replace `tolist(var.my_map)` with `values(var.my_map)`.",
        ],
        "debrief": """\
# Type Conversion

## What Was Broken
`tolist()` is used to convert tuples and sets to lists. It cannot convert maps because maps
have key-value pairs, not ordered elements.

## The Fix
```hcl
locals {
  as_list = values(var.my_map)
  # → ["apple", "banana"] (order may vary)
}
```

## Map-to-List Conversions
```hcl
keys(map)              # list of keys:   ["a", "b"]
values(map)            # list of values: ["apple", "banana"]
[for k, v in map : v]  # same as values, but with transformation
```

## tolist() Valid Uses
```hcl
tolist(toset(["a","b","c"]))   # set → list
tolist(["a","b","c"])          # tuple → list (explicit typing)
```

## Why It Matters
Terraform's type system distinguishes lists, sets, tuples, and maps. Using the wrong conversion
function is a type error caught at validate time.
""",
        "common_mistakes": """\
# Common Mistakes

- **`tolist()` on maps** — not supported; use `values()` or `keys()`.
- **Assuming map value order** — `values()` returns values in lexicographic key order in Terraform 0.15+.
- **`toset()` vs `tolist()`** — `toset` removes duplicates and has no order; `tolist` preserves order.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 15 — ternary
# ─────────────────────────────────────────────────────────────────────────────
def _level_15_ternary():
    broken_main = """\
variable "enabled" {
  type    = bool
  default = true
}

# BUG: mismatched types — "yes" is string, 0 is number
locals {
  status = var.enabled ? "yes" : 0
}

output "status" {
  value = local.status
}
"""
    solution_main = """\
variable "enabled" {
  type    = bool
  default = true
}

locals {
  status = var.enabled ? "yes" : "no"
}

output "status" {
  value = local.status
}
"""
    return {
        "module": MODULE,
        "slug": "level-15-ternary",
        "mission": {
            "name": "Ternary Operator",
            "description": "`var.enabled ? \"yes\" : 0` mixes types — the true branch is a string `\"yes\"` but the false branch is a number `0`. Both branches must be the same type.",
            "objective": "Fix the false branch to be a string: `var.enabled ? \"yes\" : \"no\"` so `terraform validate` passes.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["ternary operator", "type consistency"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate` — it reports a type inconsistency between the true and false branches.",
            "Both branches of a ternary expression must evaluate to the same type. `\"yes\"` is a string; `0` is a number.",
            "Change `0` to `\"no\"` so both branches are strings.",
        ],
        "debrief": """\
# Ternary Operator

## What Was Broken
`var.enabled ? "yes" : 0` mixed a string (`"yes"`) and a number (`0`). Terraform requires
both branches of a conditional expression to have the same type.

## The Fix
```hcl
locals {
  status = var.enabled ? "yes" : "no"
}
```

## Ternary Expression
```hcl
condition ? true_value : false_value
```

Both `true_value` and `false_value` must be the same type. Terraform will attempt implicit
conversion in some cases, but mismatched primitive types (string vs number) always error.

## Common Patterns
```hcl
var.env == "prod" ? 3 : 1                    # number
var.debug ? "DEBUG" : "INFO"                  # string
var.create ? [resource.x] : []               # list
var.enabled ? local.settings : {}            # map
```

## Why It Matters
Ternary expressions are used extensively for conditional configuration. Type consistency
is required — always ensure both branches return the same type.
""",
        "common_mistakes": """\
# Common Mistakes

- **Mixed types in branches** — string vs number, list vs map — all cause type errors.
- **Nested ternaries** — hard to read; prefer `if/else` with locals or a map lookup.
- **Using non-bool conditions** — the condition must be a bool; use `tobool()` or comparison operators.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 16 — for-expression-list
# ─────────────────────────────────────────────────────────────────────────────
def _level_16_for_expression_list():
    broken_main = """\
variable "items" {
  type    = list(string)
  default = ["apple", "banana", "cherry"]
}

# BUG: var.items is list(string) — items are strings, not objects.
# Accessing .value on a string element causes an error.
locals {
  values = [for item in var.items : item.value]
}

output "values" {
  value = local.values
}
"""
    solution_main = """\
variable "items" {
  type    = list(string)
  default = ["apple", "banana", "cherry"]
}

locals {
  values = [for item in var.items : upper(item)]
}

output "values" {
  value = local.values
}
"""
    return {
        "module": MODULE,
        "slug": "level-16-for-expression-list",
        "mission": {
            "name": "For Expression List",
            "description": "`[for item in var.items : item.value]` tries to access `.value` on each string element, but `var.items` is `list(string)` — strings have no `.value` attribute.",
            "objective": "Fix the for expression to transform strings directly: `[for item in var.items : upper(item)]` so `terraform plan` succeeds.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["for expression", "list transformation"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform validate` — it reports that a string value has no attribute `value`.",
            "`var.items` is `list(string)` — each `item` is a plain string like `\"apple\"`. You can call string functions on it directly.",
            "Replace `item.value` with `upper(item)` (or any string function/expression).",
        ],
        "debrief": """\
# For Expression List

## What Was Broken
`item.value` tried to access an attribute on a string. Strings are scalar values — they have
no attributes. The fix is to use the string directly or apply a string function.

## The Fix
```hcl
locals {
  values = [for item in var.items : upper(item)]
  # → ["APPLE", "BANANA", "CHERRY"]
}
```

## For Expression Syntax
```hcl
[for <item> in <collection> : <expression>]
[for <item> in <collection> : <expression> if <condition>]
[for <key>, <value> in <map> : "<key>=<value>"]
```

## Why It Matters
For expressions are the primary tool for transforming collections in Terraform. Knowing the
element type (string, object, map) determines what operations are valid inside the expression.
""",
        "common_mistakes": """\
# Common Mistakes

- **Treating string items as objects** — `item.value` only works when `item` is an object with a `value` attribute.
- **Wrong variable type** — always check whether the input is `list(string)`, `list(object(...))`, or `map(...)`.
- **Using index instead of value** — use `[for i, v in list : ...]` to get both index and value.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 17 — for-expression-map
# ─────────────────────────────────────────────────────────────────────────────
def _level_17_for_expression_map():
    broken_main = """\
variable "tags" {
  type = map(string)
  default = {
    env  = "production"
    team = "platform"
  }
}

# BUG: map-producing for expression uses comma instead of =>
locals {
  tag_map = {for k, v in var.tags : k, v}
}

output "tag_map" {
  value = local.tag_map
}
"""
    solution_main = """\
variable "tags" {
  type = map(string)
  default = {
    env  = "production"
    team = "platform"
  }
}

locals {
  tag_map = {for k, v in var.tags : k => v}
}

output "tag_map" {
  value = local.tag_map
}
"""
    return {
        "module": MODULE,
        "slug": "level-17-for-expression-map",
        "mission": {
            "name": "For Expression Map",
            "description": "`{for k, v in var.tags : k, v}` uses a comma between the key and value expressions. Map-producing for expressions require `=>` as the separator.",
            "objective": "Change the comma to `=>`: `{for k, v in var.tags : k => v}` so `terraform validate` passes.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["for expression", "map production"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate` — it reports a syntax error in the for expression.",
            "List-producing for expressions produce values: `[for item in list : item]`. Map-producing expressions produce key-value pairs: `{for k, v in map : k => v}`.",
            "Change `k, v` to `k => v` in the for expression.",
        ],
        "debrief": """\
# For Expression Map

## What Was Broken
`{for k, v in var.tags : k, v}` used a comma where `=>` is required. In HCL, the `=>`
(fat arrow) separates the key expression from the value expression in a map-producing for
expression.

## The Fix
```hcl
locals {
  tag_map = {for k, v in var.tags : k => v}
}
```

## For Expression Syntax: List vs Map
```hcl
# List-producing
[for v in collection : expression]

# Map-producing (key => value)
{for k, v in collection : key_expr => value_expr}
{for k, v in collection : key_expr => value_expr if condition}
```

## Transformation Examples
```hcl
# Uppercase all tag values
{for k, v in var.tags : k => upper(v)}

# Flip keys and values
{for k, v in var.tags : v => k}

# Filter and transform
{for k, v in var.tags : k => v if k != "internal"}
```

## Why It Matters
The `=>` separator is the syntactic marker that tells HCL "produce a map, not a list."
Forgetting it or using `,` is one of the most common for-expression mistakes.
""",
        "common_mistakes": """\
# Common Mistakes

- **Comma instead of `=>`** — always use `key => value` in map-producing expressions.
- **Duplicate keys** — if the key expression produces duplicates, Terraform errors; use `...` grouping mode to collect into lists.
- **Using list syntax for maps** — `[for k, v in map : k]` produces a list of keys, not a map.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 18 — for-expression-filter
# ─────────────────────────────────────────────────────────────────────────────
def _level_18_for_expression_filter():
    broken_main = """\
variable "items" {
  type    = list(string)
  default = ["5", "15", "3", "20"]
}

# BUG: var.items is list(string) — comparing strings to number 10 with > is a type error
locals {
  big_items = [for x in var.items : x if x > 10]
}

output "big_items" {
  value = local.big_items
}
"""
    solution_main = """\
variable "items" {
  type    = list(string)
  default = ["5", "15", "3", "20"]
}

locals {
  big_items = [for x in var.items : x if tonumber(x) > 10]
}

output "big_items" {
  value = local.big_items
}
"""
    return {
        "module": MODULE,
        "slug": "level-18-for-expression-filter",
        "mission": {
            "name": "For Expression Filter",
            "description": "`[for x in var.items : x if x > 10]` compares string elements to a number. `var.items` is `list(string)` — strings cannot be compared to numbers with `>`.",
            "objective": "Fix the filter by converting each element with `tonumber()`: `[for x in var.items : x if tonumber(x) > 10]` so `terraform plan` succeeds.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["for expression filter", "tonumber()", "type conversion"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform validate` — it reports a type error comparing a string to a number.",
            "`var.items` is declared as `list(string)`. To compare numerically, convert with `tonumber(x)` first.",
            "Change `if x > 10` to `if tonumber(x) > 10`.",
        ],
        "debrief": """\
# For Expression Filter

## What Was Broken
`x > 10` compared a string element to a number. Even though the strings look like numbers
(`"5"`, `"15"`), Terraform's type system requires explicit conversion.

## The Fix
```hcl
locals {
  big_items = [for x in var.items : x if tonumber(x) > 10]
  # → ["15", "20"]
}
```

## Type Conversion in Filters
When your list contains numeric strings and you need arithmetic comparisons:
```hcl
[for x in var.items : x if tonumber(x) > 10]
```

Or change the variable type to `list(number)` if the values are always numbers:
```hcl
variable "items" {
  type    = list(number)
  default = [5, 15, 3, 20]
}
# Then: [for x in var.items : x if x > 10]
```

## Why It Matters
Terraform's type system is strict about comparisons. Understanding when to use `tonumber()`,
`tostring()`, or `tobool()` prevents subtle type errors in for expressions.
""",
        "common_mistakes": """\
# Common Mistakes

- **String-to-number comparison** — always convert first with `tonumber()`.
- **Forgetting that JSON numbers become strings** — when reading from data sources or variables, numbers may arrive as strings.
- **`tonumber()` on non-numeric strings** — `tonumber("abc")` errors; use `try(tonumber(x), 0)` for safe conversion.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 19 — splat-expression
# ─────────────────────────────────────────────────────────────────────────────
def _level_19_splat_expression():
    broken_main = """\
# BUG: splat expression used on a single resource without count or for_each.
# local_file.config is a single instance, not a list — [*] requires count/for_each.

resource "local_file" "config" {
  content  = "config content"
  filename = "${path.module}/config.txt"
}

output "all_filenames" {
  value = local_file.config[*].filename
}
"""
    solution_main = """\
resource "local_file" "config" {
  count    = 2
  content  = "config content ${count.index}"
  filename = "${path.module}/config-${count.index}.txt"
}

output "all_filenames" {
  value = local_file.config[*].filename
}
"""
    return {
        "module": MODULE,
        "slug": "level-19-splat-expression",
        "mission": {
            "name": "Splat Expression",
            "description": "`local_file.config[*].filename` uses a splat expression on a single resource that has no `count` or `for_each`. Splat expressions require the resource to produce a list (i.e., use `count`).",
            "objective": "Add `count = 2` to the `local_file.config` resource (and update `content` and `filename` to use `count.index`) so the splat expression is valid.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["splat expression", "count", "resource lists"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform validate` — it reports that a splat expression cannot be applied to a single resource instance.",
            "Splat expressions (`resource[*].attr`) work when a resource has `count` or `for_each`, producing a list or map.",
            "Add `count = 2` to the resource and use `count.index` in `content` and `filename` to make them unique.",
        ],
        "debrief": """\
# Splat Expression

## What Was Broken
`local_file.config[*].filename` used a splat expression on a resource without `count` or
`for_each`. Without these, a resource is a single instance — not iterable with `[*]`.

## The Fix
```hcl
resource "local_file" "config" {
  count    = 2
  content  = "config content ${count.index}"
  filename = "${path.module}/config-${count.index}.txt"
}

output "all_filenames" {
  value = local_file.config[*].filename
  # → ["./config-0.txt", "./config-1.txt"]
}
```

## Splat Expressions
```hcl
# resource with count → splat produces a list
resource.name[*].attribute

# resource with for_each → use values() for map iteration
values(resource.name)[*].attribute

# Alternative with for expression
[for r in resource.name : r.attribute]
```

## Why It Matters
Splat expressions are concise list comprehensions for resource attributes. They only apply
to resources that produce multiple instances via `count` or `for_each`.
""",
        "common_mistakes": """\
# Common Mistakes

- **Splat on single-instance resource** — add `count` or `for_each` first.
- **Splat on `for_each` resources** — `[*]` doesn't work on maps; use `values(resource)[*].attr`.
- **Using splat when a direct reference suffices** — for a single resource, just use `resource.name.attribute`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 20 — string-directive
# ─────────────────────────────────────────────────────────────────────────────
def _level_20_string_directive():
    broken_main = """\
variable "debug" {
  type    = string
  default = "true"
}

# BUG: %{if} requires a bool but var.debug is string "true", not bool true
locals {
  message = "%{if var.debug}DEBUG MODE ENABLED%{endif}"
}

output "message" {
  value = local.message
}
"""
    solution_main = """\
variable "debug" {
  type    = bool
  default = true
}

locals {
  message = "%{if var.debug}DEBUG MODE ENABLED%{endif}"
}

output "message" {
  value = local.message
}
"""
    return {
        "module": MODULE,
        "slug": "level-20-string-directive",
        "mission": {
            "name": "String Directives",
            "description": "`%{if var.debug}` requires a boolean condition, but `var.debug` is declared as `type = string` with default `\"true\"`. String `\"true\"` is not a bool.",
            "objective": "Change the variable type from `string` to `bool` and the default from `\"true\"` to `true` so `terraform plan` succeeds.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["string directives", "%{if}", "%{for}", "bool type"],
        },
        "broken": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": broken_main},
        "solution": {"terraform.tf": LOCAL_ONLY_TF, "main.tf": solution_main},
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform validate` — `%{if}` requires a boolean condition; a string `\"true\"` is not a bool.",
            "Change the variable `type` from `string` to `bool` and the `default` from `\"true\"` (quoted) to `true` (unquoted).",
            "In HCL, `true` (unquoted) is a boolean. `\"true\"` (quoted) is a string. They are not interchangeable in conditionals.",
        ],
        "debrief": """\
# String Directives

## What Was Broken
`%{if var.debug}` required a boolean, but `var.debug` was typed as `string`. Even though the
string value was `"true"`, it is not a boolean value in Terraform's type system.

## The Fix
```hcl
variable "debug" {
  type    = bool
  default = true   # unquoted boolean, not "true" string
}
```

## String Directives
Terraform supports directives inside string templates:

### %{if}
```hcl
"%{if condition}yes%{else}no%{endif}"
"%{if var.count > 0}has items%{endif}"
```

### %{for}
```hcl
"%{for item in var.list}${item}, %{endfor}"
```

### Tilde strips whitespace
```hcl
"%{if condition~}value%{~endif}"
```

## Why It Matters
`%{if}` is stricter than the ternary operator about type requirements. Always use `bool`
typed variables with string directives to avoid cryptic type errors.
""",
        "common_mistakes": """\
# Common Mistakes

- **`"true"` vs `true`** — quoted strings are never booleans; use unquoted `true`/`false`.
- **Forgetting `%{endif}`** — every `%{if}` must have a matching `%{endif}`.
- **Whitespace in directives** — use `~` to trim surrounding whitespace: `%{if cond~}...%{~endif}`.
""",
    }


if __name__ == "__main__":
    build()
