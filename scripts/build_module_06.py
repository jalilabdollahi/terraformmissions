#!/usr/bin/env python3
"""Module 6 — Reusable Modules (20 levels, Intermediate)."""
from __future__ import annotations

import textwrap

from scripts.build_utils import (
    LOCAL_ONLY_TF,
    print_done,
    validate_tf_plan,
    validate_tf_validate,
    write_level,
)

MODULE = "module-6-modules"

# ── Shared child-module snippets ──────────────────────────────────────────────

_HELLO_MODULE_MAIN = """\
resource "local_file" "msg" {
  content  = "hello"
  filename = "${path.module}/hello.txt"
}
"""

_HELLO_MODULE_OUTPUTS = """\
output "file_path" {
  value = local_file.msg.filename
}
"""

_APPNAME_MODULE_MAIN = """\
variable "app_name" {
  type        = string
  description = "Name of the application"
}

resource "local_file" "app" {
  content  = "app=${var.app_name}"
  filename = "${path.module}/app.txt"
}
"""

_APPNAME_MODULE_OUTPUTS = """\
output "file_path" {
  value = local_file.app.filename
}
"""

_PORT_MODULE_MAIN = """\
variable "port" {
  type        = number
  description = "Port number"
}

resource "local_file" "port_file" {
  content  = "port=${var.port}"
  filename = "${path.module}/port.txt"
}
"""

_PORT_MODULE_OUTPUTS = """\
output "file_path" {
  value = local_file.port_file.filename
}
"""


def build() -> int:
    levels = [
        _level_01_module_call_basic(),
        _level_02_module_input_missing(),
        _level_03_module_input_type(),
        _level_04_module_output_reference(),
        _level_05_module_output_missing(),
        _level_06_module_count(),
        _level_07_module_for_each(),
        _level_08_module_depends_on(),
        _level_09_module_providers(),
        _level_10_nested_module(),
        _level_11_module_sensitive_output(),
        _level_12_module_variable_validation(),
        _level_13_module_precondition(),
        _level_14_module_postcondition(),
        _level_15_module_refactor_moved(),
        _level_16_module_composition(),
        _level_17_module_version_constraint(),
        _level_18_module_registry_format(),
        _level_19_module_test_basic(),
        _level_20_module_test_assert(),
    ]
    for lvl in levels:
        write_level(lvl)
    print_done(MODULE, len(levels))
    return len(levels)


# ── validate helpers ──────────────────────────────────────────────────────────

def _validate_init_plan() -> str:
    return textwrap.dedent("""\
        #!/usr/bin/env bash
        set -euo pipefail

        if ! terraform init -no-color -input=false 2>&1; then
            echo "❌ FAIL: terraform init failed"
            exit 1
        fi

        terraform plan -detailed-exitcode -no-color -input=false 2>&1
        CODE=$?
        if [[ $CODE -eq 0 ]] || [[ $CODE -eq 2 ]]; then
            echo "✅ PASS: terraform init + plan succeeded"
            exit 0
        fi
        echo "❌ FAIL: terraform plan returned error (exit $CODE)"
        exit 1
    """)


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


def _validate_terraform_test() -> str:
    return textwrap.dedent("""\
        #!/usr/bin/env bash
        set -euo pipefail

        terraform init -no-color -input=false 2>&1

        if terraform test -no-color 2>&1; then
            echo "✅ PASS: terraform test passed"
            exit 0
        fi
        echo "❌ FAIL: terraform test failed"
        exit 1
    """)


# ─────────────────────────────────────────────────────────────────────────────
# Level 1 — module-call-basic
# ─────────────────────────────────────────────────────────────────────────────
def _level_01_module_call_basic():
    return {
        "module": MODULE,
        "slug": "level-1-module-call-basic",
        "mission": {
            "name": "Wrong Module Path",
            "description": (
                "A root module calls a child module, but the `source` path is wrong — "
                "it points to `../hello` instead of the correct relative path."
            ),
            "objective": "Fix the `source` argument in the module block so `terraform init && terraform plan` succeeds.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["module source", "relative paths", "module block"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# The module source path is wrong — it points one directory UP, not into modules/hello.
module "hello" {
  source = "../hello"
}
""",
            "modules/hello/main.tf": _HELLO_MODULE_MAIN,
            "modules/hello/outputs.tf": _HELLO_MODULE_OUTPUTS,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "hello" {
  source = "./modules/hello"
}
""",
            "modules/hello/main.tf": _HELLO_MODULE_MAIN,
            "modules/hello/outputs.tf": _HELLO_MODULE_OUTPUTS,
        },
        "validate": _validate_init_plan(),
        "hints": [
            (
                "Run `terraform init` — it will fail saying it cannot find the module source. "
                "Look at the `source` value in the `module` block."
            ),
            (
                "The child module lives at `./modules/hello/` relative to the root. "
                "`../hello` would go *up* one directory from where you are."
            ),
            "Change `source = \"../hello\"` to `source = \"./modules/hello\"`.",
        ],
        "debrief": """\
# Wrong Module Path

## What Was Broken
`source = "../hello"` points to a directory one level *above* the workspace root, which does not exist.
The child module files live at `./modules/hello/` relative to the root.

## Module Source Paths
Local module sources are relative to the file containing the `module` block:

```hcl
module "hello" {
  source = "./modules/hello"   # correct
}
module "hello" {
  source = "../hello"          # goes up — usually wrong from the root
}
```

## After Changing the Path
Run `terraform init` to register the new source, then `terraform plan` to verify.

## Concepts
- `module` block — declares a call to a child module
- `source` — required argument; can be local path, Git URL, or registry address
- Local paths must start with `./` or `../`
""",
        "common_mistakes": """\
# Common Mistakes

- **Missing `./` prefix** — `source = "modules/hello"` (no leading `./`) is interpreted as a registry address, not a local path.
- **Wrong relative level** — `../` goes up one directory; only use it if the module really is a sibling of the root.
- **Forgetting `terraform init`** — changing `source` requires re-running `terraform init`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 2 — module-input-missing
# ─────────────────────────────────────────────────────────────────────────────
def _level_02_module_input_missing():
    return {
        "module": MODULE,
        "slug": "level-2-module-input-missing",
        "mission": {
            "name": "Missing Module Input",
            "description": (
                "The child module declares a required variable `app_name` with no default value, "
                "but the root module call forgets to pass it."
            ),
            "objective": "Add the missing `app_name` argument to the module call so `terraform validate` passes.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["required module inputs", "module variables", "module arguments"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# app_name is required by the child module but is not passed here.
module "myapp" {
  source = "./modules/app"
}
""",
            "modules/app/main.tf": _APPNAME_MODULE_MAIN,
            "modules/app/outputs.tf": _APPNAME_MODULE_OUTPUTS,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "myapp" {
  source   = "./modules/app"
  app_name = "myapp"
}
""",
            "modules/app/main.tf": _APPNAME_MODULE_MAIN,
            "modules/app/outputs.tf": _APPNAME_MODULE_OUTPUTS,
        },
        "validate": validate_tf_validate(),
        "hints": [
            (
                "Run `terraform validate`. The error says a required variable has no value — "
                "look at what variables the child module declares."
            ),
            (
                "Open `modules/app/main.tf`. It declares `variable \"app_name\" {}` without a default, "
                "making it required."
            ),
            "Add `app_name = \"myapp\"` inside the `module \"myapp\"` block.",
        ],
        "debrief": """\
# Missing Module Input

## What Was Broken
The child module declares `variable "app_name"` without a `default` value, making it **required**.
The root's `module` block did not supply a value for it.

## Required vs Optional Variables
```hcl
# Required — no default:
variable "app_name" {
  type = string
}

# Optional — has a default:
variable "app_name" {
  type    = string
  default = "app"
}
```

## The Fix
Pass the value from the root:
```hcl
module "myapp" {
  source   = "./modules/app"
  app_name = "myapp"   # required argument
}
```

## Concepts
- Child module variables without `default` are required.
- Root passes values as named arguments in the `module` block.
""",
        "common_mistakes": """\
# Common Mistakes

- **Passing via `var.` prefix** — `app_name = var.app_name` is valid only if the root also has a variable; for a literal, just use the string directly.
- **Wrong argument name** — the argument name in the module call must exactly match the variable name in the child.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 3 — module-input-type
# ─────────────────────────────────────────────────────────────────────────────
def _level_03_module_input_type():
    return {
        "module": MODULE,
        "slug": "level-3-module-input-type",
        "mission": {
            "name": "Type Mismatch at the Module Boundary",
            "description": (
                "The child module expects `var.port` as a `number`, "
                "but the root passes a string `\"8080\"` (with quotes)."
            ),
            "objective": "Fix the type mismatch so `terraform validate` passes.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["module input types", "type system", "number vs string"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# port must be a number but a string is being passed.
module "server" {
  source = "./modules/server"
  port   = "8080"
}
""",
            "modules/server/main.tf": _PORT_MODULE_MAIN,
            "modules/server/outputs.tf": _PORT_MODULE_OUTPUTS,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "server" {
  source = "./modules/server"
  port   = 8080
}
""",
            "modules/server/main.tf": _PORT_MODULE_MAIN,
            "modules/server/outputs.tf": _PORT_MODULE_OUTPUTS,
        },
        "validate": validate_tf_validate(),
        "hints": [
            (
                "Run `terraform validate`. The error says the value is wrong type — "
                "a `string` was given where a `number` is expected."
            ),
            "Look at the child module's `variable \"port\"` declaration — it has `type = number`.",
            "Remove the quotes: `port = 8080` (not `\"8080\"`).",
        ],
        "debrief": """\
# Type Mismatch at the Module Boundary

## What Was Broken
`port = "8080"` passes a *string*. The child module's variable declares `type = number`,
so Terraform rejects the value with a type error.

## HCL Literal Types
```hcl
port = "8080"   # string
port = 8080     # number
port = true     # bool
```

## Terraform's Type System at Module Boundaries
When a root module passes a value to a child module, Terraform enforces the declared type constraint.
While Terraform can sometimes auto-convert (e.g., `"1"` to `1`), explicit mismatches like passing
a clearly quoted string for a `number` type are rejected at validation time.

## Concepts
- `type = number` — accepts integers and floats, not quoted strings
- Quotes in HCL always produce a string literal
""",
        "common_mistakes": """\
# Common Mistakes

- **Quoting numbers** — always a source of confusion; `8080` and `"8080"` look similar but have different types.
- **Assuming auto-conversion** — Terraform does coerce some types, but not reliably; always match the declared type.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 4 — module-output-reference
# ─────────────────────────────────────────────────────────────────────────────
def _level_04_module_output_reference():
    return {
        "module": MODULE,
        "slug": "level-4-module-output-reference",
        "mission": {
            "name": "Wrong Output Name",
            "description": (
                "The root module references `module.mymod.wrong_output` — "
                "an output that doesn't exist in the child module."
            ),
            "objective": "Fix the output reference to use the correct output name `file_path`.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["module outputs", "output references", "module address"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "mymod" {
  source = "./modules/hello"
}

# This references a non-existent output 'wrong_output'.
output "result" {
  value = module.mymod.wrong_output
}
""",
            "modules/hello/main.tf": _HELLO_MODULE_MAIN,
            "modules/hello/outputs.tf": _HELLO_MODULE_OUTPUTS,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "mymod" {
  source = "./modules/hello"
}

output "result" {
  value = module.mymod.file_path
}
""",
            "modules/hello/main.tf": _HELLO_MODULE_MAIN,
            "modules/hello/outputs.tf": _HELLO_MODULE_OUTPUTS,
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says the module has no output named `wrong_output`.",
            "Look at `modules/hello/outputs.tf` to see what outputs the child module actually declares.",
            "Change `module.mymod.wrong_output` to `module.mymod.file_path`.",
        ],
        "debrief": """\
# Wrong Output Name

## What Was Broken
`module.mymod.wrong_output` references an output called `wrong_output` that the child module does not declare.
The child only exposes `file_path`.

## Module Output Reference Syntax
```
module.<module_label>.<output_name>
```

To know which outputs are available, check the child module's `outputs.tf`:
```hcl
output "file_path" {
  value = local_file.msg.filename
}
```

Then reference it from the root:
```hcl
output "result" {
  value = module.mymod.file_path
}
```

## Concepts
- Only declared `output` blocks are accessible from a parent module.
- Referencing a non-existent output is a validation error, not a runtime error.
""",
        "common_mistakes": """\
# Common Mistakes

- **Assuming all resource attributes are exposed** — only explicitly declared `output` blocks are accessible.
- **Typos in output names** — `file_path` vs `filepath` vs `file-path` are all different names.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 5 — module-output-missing
# ─────────────────────────────────────────────────────────────────────────────
def _level_05_module_output_missing():
    _child_main_no_output = """\
resource "local_file" "greeting" {
  content  = "hello world"
  filename = "${path.module}/greeting.txt"
}

# Missing: no output block — the parent cannot access the filename.
"""
    _child_main_with_output = """\
resource "local_file" "greeting" {
  content  = "hello world"
  filename = "${path.module}/greeting.txt"
}

output "filename" {
  value = local_file.greeting.filename
}
"""
    return {
        "module": MODULE,
        "slug": "level-5-module-output-missing",
        "mission": {
            "name": "Missing Output Declaration",
            "description": (
                "The child module creates a file but declares no `output` block. "
                "The root tries to reference `module.mymod.filename` which doesn't exist."
            ),
            "objective": "Add an `output \"filename\"` block to the child module so the root can access the value.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["module outputs", "output declaration", "child module encapsulation"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "mymod" {
  source = "./modules/greeter"
}

output "the_file" {
  value = module.mymod.filename
}
""",
            "modules/greeter/main.tf": _child_main_no_output,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "mymod" {
  source = "./modules/greeter"
}

output "the_file" {
  value = module.mymod.filename
}
""",
            "modules/greeter/main.tf": _child_main_with_output,
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says the module has no output named `filename`.",
            "The child module at `modules/greeter/main.tf` creates `local_file.greeting` — it just doesn't expose the filename.",
            (
                "Add to the child module:\n"
                "```hcl\n"
                "output \"filename\" {\n"
                "  value = local_file.greeting.filename\n"
                "}\n"
                "```"
            ),
        ],
        "debrief": """\
# Missing Output Declaration

## What Was Broken
A child module's resources are fully encapsulated — the parent cannot access their attributes
unless the child explicitly exposes them via an `output` block.

## Adding an Output to the Child Module
```hcl
output "filename" {
  value = local_file.greeting.filename
}
```

This makes `module.mymod.filename` available in the root.

## Encapsulation Principle
Child modules are black boxes. You must explicitly choose what to expose.
This is intentional: it keeps module APIs clean and stable.

## Concepts
- `output` blocks in a child module form its public interface.
- Resources inside a child module are never directly addressable from a parent.
""",
        "common_mistakes": """\
# Common Mistakes

- **Trying to access `module.mymod.local_file.greeting.filename`** — you cannot reach into a child's resources directly.
- **Adding the output to the wrong file** — the output must be in the child module directory, not the root.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 6 — module-count
# ─────────────────────────────────────────────────────────────────────────────
def _level_06_module_count():
    _child_main = """\
variable "name" {
  type        = string
  description = "Name for the file"
}

resource "local_file" "item" {
  content  = "item: ${var.name}"
  filename = "${path.module}/item-${var.name}.txt"
}
"""
    _child_outputs = """\
output "file_path" {
  value = local_file.item.filename
}
"""
    return {
        "module": MODULE,
        "slug": "level-6-module-count",
        "mission": {
            "name": "Count Without count.index",
            "description": (
                "A module is called with `count = 2` but no `name` argument is passed. "
                "The child module requires `name`, so validation fails."
            ),
            "objective": "Pass `name = \"app-${count.index}\"` to the module so each instance gets a unique name.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["module count", "count.index", "unique resource names"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# count = 2 but name is not passed — the child module requires it.
module "mymod" {
  count  = 2
  source = "./modules/item"
}
""",
            "modules/item/main.tf": _child_main,
            "modules/item/outputs.tf": _child_outputs,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "mymod" {
  count  = 2
  source = "./modules/item"
  name   = "app-${count.index}"
}
""",
            "modules/item/main.tf": _child_main,
            "modules/item/outputs.tf": _child_outputs,
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform validate`. The error says `name` is a required variable and has no value.",
            (
                "When using `count`, you can use `count.index` (0, 1, 2, …) inside the module block "
                "to create unique argument values for each instance."
            ),
            "Add `name = \"app-${count.index}\"` to the module block.",
        ],
        "debrief": """\
# Count Without count.index

## What Was Broken
The child module requires `var.name`. The `count = 2` meta-argument creates two instances,
but no `name` was passed at all.

## Using `count.index`
Inside a `module` block (or `resource` block) that uses `count`, `count.index` evaluates
to the current instance index (0-based):

```hcl
module "mymod" {
  count  = 2
  source = "./modules/item"
  name   = "app-${count.index}"   # "app-0", "app-1"
}
```

## Referencing Counted Module Outputs
```hcl
module.mymod[0].file_path
module.mymod[1].file_path
module.mymod[*].file_path   # splat — all instances
```

## Concepts
- `count.index` — zero-based index of the current instance
- Each module instance must produce unique resource addresses
""",
        "common_mistakes": """\
# Common Mistakes

- **Hardcoding the name** — `name = "app"` in a `count`-based module causes all instances to collide.
- **One-based indexing** — `count.index` starts at 0, not 1.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 7 — module-for-each
# ─────────────────────────────────────────────────────────────────────────────
def _level_07_module_for_each():
    _child_main = """\
variable "label" {
  type = string
}

resource "local_file" "item" {
  content  = "label=${var.label}"
  filename = "${path.module}/item-${var.label}.txt"
}
"""
    _child_outputs = """\
output "file_path" {
  value = local_file.item.filename
}
"""
    return {
        "module": MODULE,
        "slug": "level-7-module-for-each",
        "mission": {
            "name": "for_each Module Reference",
            "description": (
                "A module is called with `for_each = toset([\"a\", \"b\"])`. "
                "The root output references `module.mods.file_path` instead of "
                "`module.mods[\"a\"].file_path` — module instances must be addressed by key."
            ),
            "objective": "Fix the output so it correctly references a specific `for_each` module instance.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["module for_each", "each.key", "module instance addressing"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "mods" {
  for_each = toset(["a", "b"])
  source   = "./modules/item"
  label    = each.key
}

# Wrong: module.mods.file_path — for_each modules must be addressed by key.
output "first_file" {
  value = module.mods.file_path
}
""",
            "modules/item/main.tf": _child_main,
            "modules/item/outputs.tf": _child_outputs,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "mods" {
  for_each = toset(["a", "b"])
  source   = "./modules/item"
  label    = each.key
}

output "first_file" {
  value = module.mods["a"].file_path
}
""",
            "modules/item/main.tf": _child_main,
            "modules/item/outputs.tf": _child_outputs,
        },
        "validate": validate_tf_validate(),
        "hints": [
            (
                "Run `terraform validate`. The error says you can't reference a `for_each` module "
                "without specifying a key."
            ),
            (
                "With `for_each`, each module instance is addressed as `module.mods[\"key\"]`. "
                "The keys here are `\"a\"` and `\"b\"`."
            ),
            "Change `module.mods.file_path` to `module.mods[\"a\"].file_path`.",
        ],
        "debrief": """\
# for_each Module Reference

## What Was Broken
When a module uses `for_each`, it creates multiple instances, each identified by a key.
You cannot reference the module collection as a whole without specifying a key.

## Addressing for_each Instances
```hcl
module.mods["a"].file_path   # specific instance
module.mods["b"].file_path   # specific instance

# To get all file paths:
{ for k, mod in module.mods : k => mod.file_path }
```

## In the Module Block
```hcl
module "mods" {
  for_each = toset(["a", "b"])
  source   = "./modules/item"
  label    = each.key    # available inside the module block
}
```

## Concepts
- `for_each` module instances are addressed with `["key"]` notation.
- `each.key` / `each.value` are available inside the `module` block.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `[0]` index on a for_each module** — for_each uses string keys, not numeric indices.
- **Forgetting `each.key`** — inside the module block, use `each.key`/`each.value` to pass per-instance values.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 8 — module-depends-on
# ─────────────────────────────────────────────────────────────────────────────
def _level_08_module_depends_on():
    return {
        "module": MODULE,
        "slug": "level-8-module-depends-on",
        "mission": {
            "name": "Broken depends_on Reference",
            "description": (
                "`depends_on = [module.nonexistent]` references a module that doesn't exist, "
                "causing a validation error."
            ),
            "objective": "Remove or fix the `depends_on` so it references a real module or resource.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["module depends_on", "explicit dependencies", "reference validation"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "hello" {
  source = "./modules/hello"
}

# This resource depends on a module that doesn't exist.
resource "local_file" "note" {
  content  = "dependency test"
  filename = "${path.module}/note.txt"
  depends_on = [module.nonexistent]
}
""",
            "modules/hello/main.tf": _HELLO_MODULE_MAIN,
            "modules/hello/outputs.tf": _HELLO_MODULE_OUTPUTS,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "hello" {
  source = "./modules/hello"
}

resource "local_file" "note" {
  content  = "dependency test"
  filename = "${path.module}/note.txt"
  depends_on = [module.hello]
}
""",
            "modules/hello/main.tf": _HELLO_MODULE_MAIN,
            "modules/hello/outputs.tf": _HELLO_MODULE_OUTPUTS,
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. It says `module.nonexistent` is not declared.",
            "Look at what modules are actually declared in the configuration — only `module.hello` exists.",
            "Change `module.nonexistent` to `module.hello` in the `depends_on` list.",
        ],
        "debrief": """\
# Broken depends_on Reference

## What Was Broken
`depends_on = [module.nonexistent]` references a module label that is not declared anywhere.
Terraform validates all references at plan time, including `depends_on` arguments.

## depends_on Syntax
```hcl
resource "local_file" "note" {
  # ...
  depends_on = [module.hello]   # references a real module
}
```

## When to Use depends_on with Modules
Use `depends_on` on a module call to express that everything inside the module
should wait until the dependency is complete:
```hcl
module "app" {
  source     = "./modules/app"
  depends_on = [module.network]
}
```

## Concepts
- All `depends_on` values are validated — they must refer to declared resources or modules.
- `depends_on` forces ordering but does not pass data between objects.
""",
        "common_mistakes": """\
# Common Mistakes

- **Referencing a resource that doesn't exist** — same problem; always check the exact label.
- **Overusing depends_on** — prefer data-driven dependencies (referencing outputs) over explicit `depends_on` when possible.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 9 — module-providers
# ─────────────────────────────────────────────────────────────────────────────
def _level_09_module_providers():
    _child_main = """\
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "msg" {
  content  = "provider alias test"
  filename = "${path.module}/msg.txt"
}
"""
    return {
        "module": MODULE,
        "slug": "level-9-module-providers",
        "mission": {
            "name": "Wrong Provider Alias in Module",
            "description": (
                "The root passes `providers = { local = local.wrong_alias }` to the child module, "
                "but the alias `local.wrong_alias` is not declared in the root provider config."
            ),
            "objective": "Fix the `providers` map to reference the declared provider alias `local.primary`.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["provider aliases", "module providers argument", "provider configuration"],
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

provider "local" {
  alias = "primary"
}
""",
            "main.tf": """\
# wrong_alias does not exist — only 'primary' is declared above.
module "mymod" {
  source = "./modules/writer"
  providers = {
    local = local.wrong_alias
  }
}
""",
            "modules/writer/main.tf": _child_main,
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
}

provider "local" {
  alias = "primary"
}
""",
            "main.tf": """\
module "mymod" {
  source = "./modules/writer"
  providers = {
    local = local.primary
  }
}
""",
            "modules/writer/main.tf": _child_main,
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error mentions `local.wrong_alias` is not declared.",
            "Look at the `provider` blocks in `terraform.tf` — only `alias = \"primary\"` is defined.",
            "Change `local.wrong_alias` to `local.primary` in the `providers` map.",
        ],
        "debrief": """\
# Wrong Provider Alias in Module

## What Was Broken
The `providers` argument in the module block mapped `local` to `local.wrong_alias`,
but the root only declares `provider "local" { alias = "primary" }`.

## Provider Aliases Syntax
```hcl
provider "local" {
  alias = "primary"   # declares alias
}

module "mymod" {
  source = "./modules/writer"
  providers = {
    local = local.primary   # pass alias to child
  }
}
```

## Why Pass Providers to Modules
By default a module inherits the default (un-aliased) provider configuration.
Use `providers` to explicitly pass a specific alias when you have multiple
configurations for the same provider type.

## Concepts
- Provider aliases are referenced as `<type>.<alias>` (e.g., `local.primary`)
- The `providers` map in a module call remaps provider types for the child
""",
        "common_mistakes": """\
# Common Mistakes

- **Using the alias name as a string** — `local = "primary"` is wrong; use `local = local.primary` (no quotes).
- **Forgetting to declare the alias** — the `provider` block with `alias` must exist in the root.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 10 — nested-module path
# ─────────────────────────────────────────────────────────────────────────────
def _level_10_nested_module():
    _child_broken = """\
# Using path.root instead of path.module — path.root is the root module's directory,
# which is NOT where this child module's files live.
resource "local_file" "config" {
  content  = "generated config"
  filename = "${path.root}/child-config.txt"
}
"""
    _child_fixed = """\
resource "local_file" "config" {
  content  = "generated config"
  filename = "${path.module}/child-config.txt"
}
"""
    _child_outputs = """\
output "file_path" {
  value = local_file.config.filename
}
"""
    return {
        "module": MODULE,
        "slug": "level-10-nested-module",
        "mission": {
            "name": "path.root vs path.module",
            "description": (
                "A child module uses `path.root` where it should use `path.module`. "
                "`path.root` is the root module's directory — not where the child module lives."
            ),
            "objective": "Replace `path.root` with `path.module` inside the child module.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["path.module", "path.root", "module filesystem paths"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "child" {
  source = "./modules/child"
}
""",
            "modules/child/main.tf": _child_broken,
            "modules/child/outputs.tf": _child_outputs,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "child" {
  source = "./modules/child"
}
""",
            "modules/child/main.tf": _child_fixed,
            "modules/child/outputs.tf": _child_outputs,
        },
        "validate": validate_tf_plan(),
        "hints": [
            (
                "Run `terraform plan`. Observe where the output file would be written — "
                "it uses `path.root`, which is the *root* module's directory."
            ),
            (
                "`path.module` evaluates to the directory containing the *current* module's config files. "
                "In a child module, this is the child's directory, not the root's."
            ),
            "In `modules/child/main.tf`, change `${path.root}` to `${path.module}`.",
        ],
        "debrief": """\
# path.root vs path.module

## Path Variables in Terraform
| Variable      | Value |
|--------------|-------|
| `path.module` | Directory of the **current** module's `.tf` files |
| `path.root`   | Directory of the **root** module |
| `path.cwd`    | Current working directory when Terraform was invoked |

## Why It Matters in Child Modules
Inside a child module, `path.root` still points to the *root* module.
If the child writes files using `${path.root}/...`, those files land in the
root's directory, not next to the child module's files.

## Best Practice
In child modules, use `path.module` for file paths relative to the module's own directory:
```hcl
filename = "${path.module}/output.txt"   # child's directory
filename = "${path.root}/output.txt"     # root's directory (probably wrong in a child)
```
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `path.root` in child modules** — almost always the wrong choice; use `path.module`.
- **Confusing `path.cwd` and `path.module`** — `path.cwd` is where `terraform` was invoked, not where the `.tf` file lives.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 11 — module-sensitive-output
# ─────────────────────────────────────────────────────────────────────────────
def _level_11_module_sensitive_output():
    _child_broken = """\
variable "secret" {
  type      = string
  sensitive = true
}

resource "local_file" "secret_file" {
  content  = var.secret
  filename = "${path.module}/secret.txt"
}

# Missing: sensitive = true on this output
output "secret_content" {
  value = var.secret
}
"""
    _child_fixed = """\
variable "secret" {
  type      = string
  sensitive = true
}

resource "local_file" "secret_file" {
  content  = var.secret
  filename = "${path.module}/secret.txt"
}

output "secret_content" {
  value     = var.secret
  sensitive = true
}
"""
    return {
        "module": MODULE,
        "slug": "level-11-module-sensitive-output",
        "mission": {
            "name": "Sensitive Output Leak",
            "description": (
                "A child module takes a `sensitive` variable and returns it as an output, "
                "but the output doesn't declare `sensitive = true`. Terraform will error "
                "because a sensitive value flows into a non-sensitive output."
            ),
            "objective": "Add `sensitive = true` to the child module's output block.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["sensitive outputs", "module sensitive values", "output sensitivity"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "secrets" {
  source = "./modules/secrets"
  secret = "s3cr3t-v4lue"
}
""",
            "modules/secrets/main.tf": _child_broken,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "secrets" {
  source = "./modules/secrets"
  secret = "s3cr3t-v4lue"
}
""",
            "modules/secrets/main.tf": _child_fixed,
        },
        "validate": validate_tf_plan(),
        "hints": [
            (
                "Run `terraform plan`. Terraform warns or errors that a sensitive value "
                "is being used in a non-sensitive output."
            ),
            "When a sensitive variable flows into an output, that output must also be marked `sensitive = true`.",
            "Add `sensitive = true` to the `output \"secret_content\"` block in the child module.",
        ],
        "debrief": """\
# Sensitive Output Leak

## What Was Broken
`var.secret` is declared `sensitive = true`. When that value flows into an `output` block,
Terraform requires the output to also be marked `sensitive = true`.

## Marking Outputs Sensitive
```hcl
output "secret_content" {
  value     = var.secret
  sensitive = true   # required when value is sensitive
}
```

## Sensitive Propagation Rules
- A sensitive value used anywhere in an output's `value` expression makes the entire output sensitive.
- Terraform will raise an error if you try to use a sensitive value in a non-sensitive output.
- Sensitive outputs are displayed as `(sensitive value)` in `terraform output`.

## Concepts
- `sensitive = true` on a variable or output hides the value in logs/output.
- Sensitivity propagates through expressions — you must mark the output sensitive too.
""",
        "common_mistakes": """\
# Common Mistakes

- **Forgetting `sensitive = true` on outputs** — if the value comes from a sensitive variable, the output must be sensitive.
- **Assuming `sensitive` on a variable hides everything** — it only applies to Terraform's display; data may still be written to state.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 12 — module-variable-validation
# ─────────────────────────────────────────────────────────────────────────────
def _level_12_module_variable_validation():
    _child_broken = """\
variable "env" {
  type        = string
  description = "Deployment environment"
  validation {
    # This condition only allows the string "valid" — too restrictive!
    condition     = var.env == "valid"
    error_message = "env must be one of: dev, staging, prod."
  }
}

resource "local_file" "env_file" {
  content  = "env=${var.env}"
  filename = "${path.module}/env.txt"
}
"""
    _child_fixed = """\
variable "env" {
  type        = string
  description = "Deployment environment"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "env must be one of: dev, staging, prod."
  }
}

resource "local_file" "env_file" {
  content  = "env=${var.env}"
  filename = "${path.module}/env.txt"
}
"""
    return {
        "module": MODULE,
        "slug": "level-12-module-variable-validation",
        "mission": {
            "name": "Overly Strict Validation",
            "description": (
                "The child module has a `validation` block that only allows `env == \"valid\"`. "
                "The root passes `env = \"prod\"` which is a real environment, but the validation rejects it."
            ),
            "objective": "Fix the validation condition to allow `dev`, `staging`, and `prod`.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["module variable validation", "contains()", "validation condition"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "deploy" {
  source = "./modules/deployer"
  env    = "prod"
}
""",
            "modules/deployer/main.tf": _child_broken,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "deploy" {
  source = "./modules/deployer"
  env    = "prod"
}
""",
            "modules/deployer/main.tf": _child_fixed,
        },
        "validate": validate_tf_plan(),
        "hints": [
            (
                "Run `terraform plan`. The error is a variable validation failure: "
                "the condition `var.env == \"valid\"` fails for `\"prod\"`."
            ),
            (
                "The validation condition is too strict. "
                "Use `contains([\"dev\", \"staging\", \"prod\"], var.env)` to allow real environments."
            ),
            "Update the `condition` line in the `validation` block inside the child module.",
        ],
        "debrief": """\
# Overly Strict Validation

## What Was Broken
The condition `var.env == "valid"` only allows the literal string `"valid"`.
Passing any real environment name (like `"prod"`) causes a validation error.

## Better Validation with contains()
```hcl
validation {
  condition     = contains(["dev", "staging", "prod"], var.env)
  error_message = "env must be one of: dev, staging, prod."
}
```

## Validation Block Syntax
```hcl
variable "env" {
  type = string
  validation {
    condition     = <bool expression using var.env>
    error_message = "Human-readable message shown on failure."
  }
}
```

## Concepts
- `contains(list, value)` — returns true if `value` is in `list`
- Validation runs at plan time before any API calls
- `error_message` must be a static string (no interpolation of `var.env`)
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `var.env` in `error_message`** — not allowed; the message must be a literal string.
- **Multiple validation blocks** — you can have multiple `validation` blocks on one variable; each is checked independently.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 13 — module-precondition
# ─────────────────────────────────────────────────────────────────────────────
def _level_13_module_precondition():
    _child_broken = """\
variable "item_count" {
  type    = number
  default = 1
}

resource "local_file" "items" {
  # Precondition requires count > 10 — but default is 1, so this always fails.
  lifecycle {
    precondition {
      condition     = var.item_count > 10
      error_message = "item_count must be greater than 10."
    }
  }
  content  = "items: ${var.item_count}"
  filename = "${path.module}/items.txt"
}
"""
    _child_fixed = """\
variable "item_count" {
  type    = number
  default = 1
}

resource "local_file" "items" {
  lifecycle {
    precondition {
      condition     = var.item_count > 0
      error_message = "item_count must be greater than 0."
    }
  }
  content  = "items: ${var.item_count}"
  filename = "${path.module}/items.txt"
}
"""
    return {
        "module": MODULE,
        "slug": "level-13-module-precondition",
        "mission": {
            "name": "Impossible Precondition",
            "description": (
                "A child module resource has a `precondition` that requires `var.item_count > 10`, "
                "but the variable defaults to `1`. The precondition always fails."
            ),
            "objective": "Fix the precondition to `var.item_count > 0` so the default value passes.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["lifecycle precondition", "custom conditions", "module lifecycle"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "generator" {
  source = "./modules/generator"
}
""",
            "modules/generator/main.tf": _child_broken,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "generator" {
  source = "./modules/generator"
}
""",
            "modules/generator/main.tf": _child_fixed,
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. It fails with a precondition error: `item_count must be greater than 10`.",
            "The variable `item_count` defaults to `1`. A precondition of `> 10` can never pass with the default.",
            "Change the condition to `var.item_count > 0` so any positive count passes.",
        ],
        "debrief": """\
# Impossible Precondition

## What Was Broken
`precondition { condition = var.item_count > 10 }` requires a value greater than 10.
With `default = 1`, this condition always fails.

## lifecycle Precondition
```hcl
resource "local_file" "items" {
  lifecycle {
    precondition {
      condition     = var.item_count > 0   # sensible guard
      error_message = "item_count must be greater than 0."
    }
  }
  # ...
}
```

## Precondition vs Validation
| Feature | `validation` block | `lifecycle precondition` |
|--------|-------------------|--------------------------|
| Where | `variable` block | `resource` / `data` lifecycle |
| When | Plan time (variable evaluation) | Plan time (resource evaluation) |
| Scope | Variable value only | Can reference other values |

## Concepts
- Preconditions check assumptions about the context in which a resource is used.
- They run during plan and apply phases.
""",
        "common_mistakes": """\
# Common Mistakes

- **Precondition vs postcondition** — `precondition` asserts inputs are correct; `postcondition` asserts outputs are correct.
- **Too-strict conditions** — make sure the condition is satisfiable with realistic inputs.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 14 — module-postcondition
# ─────────────────────────────────────────────────────────────────────────────
def _level_14_module_postcondition():
    _child_broken = """\
variable "label" {
  type    = string
  default = "hello"
}

resource "local_file" "result" {
  content  = var.label
  filename = "${path.module}/result.txt"
}

output "content" {
  value = local_file.result.content
  # Wrong postcondition logic: value == "" means this passes only when empty
  postcondition {
    condition     = self.value == ""
    error_message = "content output must not be empty."
  }
}
"""
    _child_fixed = """\
variable "label" {
  type    = string
  default = "hello"
}

resource "local_file" "result" {
  content  = var.label
  filename = "${path.module}/result.txt"
}

output "content" {
  value = local_file.result.content
  postcondition {
    condition     = self.value != ""
    error_message = "content output must not be empty."
  }
}
"""
    return {
        "module": MODULE,
        "slug": "level-14-module-postcondition",
        "mission": {
            "name": "Inverted Postcondition",
            "description": (
                "An output has a `postcondition` whose condition is `self.value == \"\"` — "
                "it passes only when the value IS empty, which is backwards. "
                "The intent is to ensure the value is NOT empty."
            ),
            "objective": "Fix the postcondition to `self.value != \"\"`.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["output postcondition", "self reference", "lifecycle assertions"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "writer" {
  source = "./modules/writer"
  label  = "hello"
}
""",
            "modules/writer/main.tf": _child_broken,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "writer" {
  source = "./modules/writer"
  label  = "hello"
}
""",
            "modules/writer/main.tf": _child_fixed,
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The postcondition fails because `\"hello\" == \"\"` is false.",
            "The error message says `content output must not be empty` — but the condition is checking `== \"\"` (empty).",
            "The logic is inverted. Change `self.value == \"\"` to `self.value != \"\"`.",
        ],
        "debrief": """\
# Inverted Postcondition

## What Was Broken
`condition = self.value == ""` passes only when the output value IS the empty string.
The intent (as shown by the error message) is the opposite: ensure the value is NOT empty.

## Output Postcondition Syntax
```hcl
output "content" {
  value = local_file.result.content
  postcondition {
    condition     = self.value != ""   # passes when non-empty
    error_message = "content output must not be empty."
  }
}
```

## `self` in Postconditions
Inside an `output` block's `postcondition`, `self.value` refers to the output's own value.
Inside a `resource` block's `postcondition`, `self` refers to the resource object.

## Concepts
- `postcondition` — asserts something about the result after creation
- `self.value` — refers to the enclosing output's value
- Inverted logic (`==` vs `!=`) is a very common bug in conditions
""",
        "common_mistakes": """\
# Common Mistakes

- **`==` vs `!=`** — double-check whether your condition matches the intent.
- **Using `self` outside lifecycle blocks** — `self` is only valid inside `precondition` / `postcondition`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 15 — module-refactor-moved
# ─────────────────────────────────────────────────────────────────────────────
def _level_15_module_refactor_moved():
    _child_main = """\
resource "local_file" "data" {
  content  = "module data"
  filename = "${path.module}/data.txt"
}
"""
    _child_outputs = """\
output "file_path" {
  value = local_file.data.filename
}
"""
    return {
        "module": MODULE,
        "slug": "level-15-module-refactor-moved",
        "mission": {
            "name": "Renamed Module Without moved Block",
            "description": (
                "A module was renamed from `module.old` to `module.new` in the config, "
                "but no `moved` block was added. Terraform will plan to destroy the old "
                "instance and create a new one instead of renaming in state."
            ),
            "objective": "Add a `moved` block to tell Terraform the module was renamed, preventing destroy/create.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["moved block", "module refactoring", "state migration"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Module was renamed: 'old' -> 'new'. Without a moved block, Terraform
# will destroy module.old and create module.new.
module "new" {
  source = "./modules/datamod"
}
""",
            "modules/datamod/main.tf": _child_main,
            "modules/datamod/outputs.tf": _child_outputs,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "new" {
  source = "./modules/datamod"
}

moved {
  from = module.old
  to   = module.new
}
""",
            "modules/datamod/main.tf": _child_main,
            "modules/datamod/outputs.tf": _child_outputs,
        },
        "validate": _validate_plan_no_destroy(),
        "hints": [
            (
                "Run `terraform plan`. Without a `moved` block Terraform simply plans to create "
                "`module.new` (since `module.old` no longer exists in config)."
            ),
            (
                "A `moved` block tells Terraform that an object was renamed, so it updates "
                "the state entry in place instead of destroying and recreating."
            ),
            "Add to `main.tf`:\n```hcl\nmoved {\n  from = module.old\n  to   = module.new\n}\n```",
        ],
        "debrief": """\
# Renamed Module Without moved Block

## What Was Broken
Renaming `module "old"` to `module "new"` without a `moved` block causes Terraform
to see a new module (create) and a missing module (destroy).

## The moved Block
```hcl
moved {
  from = module.old
  to   = module.new
}
```
This instructs Terraform to update the state key from `module.old` to `module.new`,
preserving the existing resource without destroy/create.

## When to Use moved
- Renaming a module label
- Moving a resource into or out of a module
- Changing `count` to `for_each` (with appropriate key mapping)

## After Adding moved
`terraform plan` should show no changes (or only the changes you actually want).
The `moved` block can be removed in a later commit after the state migration is confirmed.

## Concepts
- `moved` block — declarative state migration
- Works for resources, module calls, and resource instances
""",
        "common_mistakes": """\
# Common Mistakes

- **Removing the moved block too soon** — keep it until all collaborators have run `terraform apply`.
- **Wrong direction** — `from` is the old address, `to` is the new address.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 16 — module-composition
# ─────────────────────────────────────────────────────────────────────────────
def _level_16_module_composition():
    _mod_a_main = """\
resource "local_file" "config" {
  content  = "database_url=postgres://localhost/mydb"
  filename = "${path.module}/config.txt"
}

output "config_path" {
  value = local_file.config.filename
}
"""
    _mod_b_main = """\
variable "config_path" {
  type        = string
  description = "Path to the config file"
}

resource "local_file" "app" {
  content  = "app config: ${var.config_path}"
  filename = "${path.module}/app.txt"
}
"""
    return {
        "module": MODULE,
        "slug": "level-16-module-composition",
        "mission": {
            "name": "Module Composition Mismatch",
            "description": (
                "Module A outputs `config_path`. The root passes that to Module B as `config_file`, "
                "but Module B's variable is named `config_path`, not `config_file`."
            ),
            "objective": "Fix the root to pass `config_path` (not `config_file`) to Module B.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["module composition", "module output to input", "wiring modules"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "mod_a" {
  source = "./modules/mod_a"
}

# Wrong: Module B expects 'config_path' but we're passing 'config_file'.
module "mod_b" {
  source      = "./modules/mod_b"
  config_file = module.mod_a.config_path
}
""",
            "modules/mod_a/main.tf": _mod_a_main,
            "modules/mod_b/main.tf": _mod_b_main,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "mod_a" {
  source = "./modules/mod_a"
}

module "mod_b" {
  source      = "./modules/mod_b"
  config_path = module.mod_a.config_path
}
""",
            "modules/mod_a/main.tf": _mod_a_main,
            "modules/mod_b/main.tf": _mod_b_main,
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. Module B doesn't have a variable called `config_file`.",
            "Look at `modules/mod_b/main.tf` — the variable is named `config_path`, not `config_file`.",
            "In the root `main.tf`, change `config_file = ...` to `config_path = ...`.",
        ],
        "debrief": """\
# Module Composition Mismatch

## What Was Broken
The root passed an argument named `config_file` to Module B, but Module B's input variable
is called `config_path`. The argument name must match the variable name exactly.

## Wiring Modules Together
```hcl
module "mod_a" {
  source = "./modules/mod_a"
}

module "mod_b" {
  source      = "./modules/mod_b"
  config_path = module.mod_a.config_path   # name matches variable
}
```

## Module Composition Pattern
Module A's output → Root wires → Module B's input.
This is the standard way to build larger systems from smaller, focused modules.

## Concepts
- Module argument names must match the child module's declared variable names.
- Use `terraform validate` to catch argument name mismatches early.
""",
        "common_mistakes": """\
# Common Mistakes

- **Assuming argument names are flexible** — they must exactly match the child module's variable names.
- **Circular dependencies** — Module A cannot depend on Module B if Module B also depends on Module A.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 17 — module-version-constraint
# ─────────────────────────────────────────────────────────────────────────────
def _level_17_module_version_constraint():
    _local_mod_main = """\
resource "local_file" "data" {
  content  = "local module content"
  filename = "${path.module}/data.txt"
}

output "file_path" {
  value = local_file.data.filename
}
"""
    return {
        "module": MODULE,
        "slug": "level-17-module-version-constraint",
        "mission": {
            "name": "Unreachable Module Source",
            "description": (
                "The root tries to source a module from a Git URL that doesn't exist. "
                "`terraform init` fails because the remote source is unreachable."
            ),
            "objective": "Change the module `source` to the local path `./modules/local` so `terraform init` succeeds.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["module sources", "local vs remote modules", "terraform init"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# This Git source doesn't exist — init will fail.
module "data" {
  source = "git::https://example-internal.invalid/terraform-modules/data.git"
}
""",
            "modules/local/main.tf": _local_mod_main,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "data" {
  source = "./modules/local"
}
""",
            "modules/local/main.tf": _local_mod_main,
        },
        "validate": _validate_init_plan(),
        "hints": [
            "Run `terraform init`. It fails trying to clone a Git repository that doesn't exist.",
            (
                "A local module already exists at `./modules/local/`. "
                "For local development, use a relative path source instead of a Git URL."
            ),
            "Change `source` to `\"./modules/local\"`.",
        ],
        "debrief": """\
# Unreachable Module Source

## What Was Broken
The `source` pointed to a Git URL for a repository that doesn't exist.
`terraform init` tries to clone it and fails.

## Module Source Types
| Source Type | Example |
|------------|---------|
| Local path | `./modules/mymod` |
| Terraform Registry | `hashicorp/consul/aws` |
| GitHub | `github.com/org/repo//modules/mod` |
| Git generic | `git::https://example.com/repo.git` |

## Local Path Sources
For modules within the same repository, use local paths:
```hcl
module "data" {
  source = "./modules/local"
}
```

Local path sources don't require internet access and are fastest for development.

## Concepts
- Local path sources must start with `./` or `../`
- `terraform init` downloads/installs all module sources
""",
        "common_mistakes": """\
# Common Mistakes

- **Using a Git URL for local modules** — unnecessary and fails without internet access.
- **Missing `./` prefix on local paths** — without it, Terraform treats the string as a registry address.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 18 — module-registry-format
# ─────────────────────────────────────────────────────────────────────────────
def _level_18_module_registry_format():
    _child_broken = """\
# The 'local_file' resource uses 'file_content' which is not a valid argument.
# The correct argument name is 'content'.
resource "local_file" "output" {
  file_content = "module output data"
  filename     = "${path.module}/output.txt"
}
"""
    _child_fixed = """\
resource "local_file" "output" {
  content  = "module output data"
  filename = "${path.module}/output.txt"
}

output "file_path" {
  value = local_file.output.filename
}
"""
    return {
        "module": MODULE,
        "slug": "level-18-module-registry-format",
        "mission": {
            "name": "Broken Child Module Syntax",
            "description": (
                "The child module uses `file_content` instead of `content` for the `local_file` resource — "
                "an invalid argument name that causes validation to fail."
            ),
            "objective": "Fix the `local_file` argument name from `file_content` to `content`.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["module structure", "resource argument names", "terraform validate"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "writer" {
  source = "./modules/writer"
}
""",
            "modules/writer/main.tf": _child_broken,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "writer" {
  source = "./modules/writer"
}
""",
            "modules/writer/main.tf": _child_fixed,
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error points to an invalid argument in the child module.",
            "Open `modules/writer/main.tf`. The `local_file` resource uses `file_content` — check the correct argument name.",
            "The `local_file` resource argument for file contents is `content`, not `file_content`.",
        ],
        "debrief": """\
# Broken Child Module Syntax

## What Was Broken
The child module used `file_content` as an argument for the `local_file` resource.
The actual argument name is `content`. Terraform's validation catches unknown arguments.

## local_file Resource Arguments
```hcl
resource "local_file" "example" {
  content  = "file contents"   # correct
  filename = "/path/to/file.txt"
}
```

## Finding Correct Argument Names
Run `terraform providers schema -json` or check the provider documentation at
`registry.terraform.io` to see all valid arguments for a resource type.

## Concepts
- Resource argument names are defined by the provider, not by you.
- `terraform validate` catches unknown argument names.
""",
        "common_mistakes": """\
# Common Mistakes

- **Guessing argument names** — always check the provider documentation or schema.
- **`content` vs `content_base64`** — use `content` for plain text, `content_base64` for binary.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 19 — module-test-basic
# ─────────────────────────────────────────────────────────────────────────────
def _level_19_module_test_basic():
    _child_main = """\
resource "local_file" "output" {
  content  = "test output"
  filename = "${path.module}/output.txt"
}

output "file_path" {
  value = local_file.output.filename
}
"""
    _test_broken = """\
# Invalid command: "apply_all" is not a valid terraform test command.
run "creates_file" {
  command = apply_all

  assert {
    condition     = output.file_path != ""
    error_message = "file_path output should not be empty"
  }
}
"""
    _test_fixed = """\
run "creates_file" {
  command = apply

  assert {
    condition     = output.file_path != ""
    error_message = "file_path output should not be empty"
  }
}
"""
    return {
        "module": MODULE,
        "slug": "level-19-module-test-basic",
        "mission": {
            "name": "Invalid Test Command",
            "description": (
                "A `.tftest.hcl` file uses `command = apply_all` which is not a valid "
                "`terraform test` command. Valid values are `apply` and `plan`."
            ),
            "objective": "Fix the test command to `apply` so `terraform test` passes.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["terraform test", "tftest.hcl", "run block", "test commands"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "output_writer" {
  source = "./modules/writer"
}
""",
            "modules/writer/main.tf": _child_main,
            "tests/basic.tftest.hcl": _test_broken,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "output_writer" {
  source = "./modules/writer"
}
""",
            "modules/writer/main.tf": _child_main,
            "tests/basic.tftest.hcl": _test_fixed,
        },
        "validate": _validate_terraform_test(),
        "hints": [
            "Run `terraform test`. It fails immediately with a syntax or command error.",
            (
                "The `run` block's `command` argument accepts only `apply` or `plan`. "
                "`apply_all` is not valid."
            ),
            "Change `command = apply_all` to `command = apply` in the `.tftest.hcl` file.",
        ],
        "debrief": """\
# Invalid Test Command

## What Was Broken
`command = apply_all` is not a valid value for the `command` argument in a `run` block.

## terraform test Basics
The `terraform test` command runs `.tftest.hcl` files (in `tests/` or the root directory).

## run Block Syntax
```hcl
run "test_name" {
  command = apply   # or "plan"

  assert {
    condition     = <bool expression>
    error_message = "Human-readable failure message"
  }
}
```

## Valid command Values
| Value | Effect |
|-------|--------|
| `apply` | Runs `terraform apply`, then checks assertions |
| `plan` | Runs `terraform plan`, then checks assertions |

## Concepts
- `.tftest.hcl` files define test runs with assertions
- `terraform test` is available from Terraform 1.6+
""",
        "common_mistakes": """\
# Common Mistakes

- **`apply_all`** — not a valid command; always use `apply` or `plan`.
- **Missing `assert` block** — a `run` block without assertions is valid but provides no value.
- **Wrong file extension** — test files must end in `.tftest.hcl`, not `.tf`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 20 — module-test-assert
# ─────────────────────────────────────────────────────────────────────────────
def _level_20_module_test_assert():
    _child_main = """\
resource "local_file" "result" {
  content  = "correct"
  filename = "${path.module}/result.txt"
}

output "result" {
  value = local_file.result.content
}
"""
    _test_broken = """\
run "check_output" {
  command = apply

  assert {
    # Wrong expected value: the module outputs "correct", not "wrong"
    condition     = output.result == "wrong"
    error_message = "result should equal 'correct'"
  }
}
"""
    _test_fixed = """\
run "check_output" {
  command = apply

  assert {
    condition     = output.result == "correct"
    error_message = "result should equal 'correct'"
  }
}
"""
    return {
        "module": MODULE,
        "slug": "level-20-module-test-assert",
        "mission": {
            "name": "Wrong Test Assertion",
            "description": (
                "The test asserts that `output.result == \"wrong\"`, "
                "but the module actually outputs `\"correct\"`. The assertion is inverted."
            ),
            "objective": "Fix the assertion condition to `output.result == \"correct\"` so `terraform test` passes.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["test assertions", "output verification", "condition expressions"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "checker" {
  source = "./modules/checker"
}
""",
            "modules/checker/main.tf": _child_main,
            "tests/assert.tftest.hcl": _test_broken,
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "checker" {
  source = "./modules/checker"
}
""",
            "modules/checker/main.tf": _child_main,
            "tests/assert.tftest.hcl": _test_fixed,
        },
        "validate": _validate_terraform_test(),
        "hints": [
            "Run `terraform test`. The assertion fails: `result should equal 'correct'`.",
            (
                "Look at the child module's output — `local_file.result.content` is `\"correct\"`. "
                "The test asserts it equals `\"wrong\"`."
            ),
            "Change `output.result == \"wrong\"` to `output.result == \"correct\"`.",
        ],
        "debrief": """\
# Wrong Test Assertion

## What Was Broken
The assert condition `output.result == "wrong"` always fails because the module outputs `"correct"`.

## Writing Good Assertions
```hcl
assert {
  condition     = output.result == "correct"   # matches actual output
  error_message = "result should equal 'correct'"
}
```

## Tips for Test Assertions
1. Run the module manually (`terraform apply`) and inspect outputs to know expected values.
2. Keep `error_message` informative — include what was expected.
3. Test both the happy path and edge cases.

## Multiple Assertions
A single `run` block can have multiple `assert` blocks:
```hcl
run "full_check" {
  command = apply

  assert {
    condition     = output.result == "correct"
    error_message = "wrong result value"
  }

  assert {
    condition     = output.result != ""
    error_message = "result must not be empty"
  }
}
```

## Concepts
- `assert` blocks are the heart of Terraform testing
- `condition` must evaluate to `true` for the test to pass
""",
        "common_mistakes": """\
# Common Mistakes

- **Asserting the wrong value** — always verify what the module actually produces before writing assertions.
- **Forgetting `command = apply`** — without apply, outputs may not be available for assertion.
""",
    }


if __name__ == "__main__":
    build()
