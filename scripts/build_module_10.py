#!/usr/bin/env python3
"""Module 10 — Terraform Testing Framework (18 levels, Advanced)."""
from __future__ import annotations

from scripts.build_utils import (
    LOCAL_ONLY_TF,
    print_done,
    validate_custom,
    write_level,
)

MODULE = "module-10-testing"

VALIDATE_TEST = validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if terraform test -no-color 2>&1; then
    echo "✅ PASS: terraform test passed"
    exit 0
fi
echo "❌ FAIL: terraform test failed"
exit 1
""")


def build() -> int:
    levels = [
        _level_01_test_file_structure(),
        _level_02_test_run_command(),
        _level_03_test_assert_basic(),
        _level_04_test_assert_message(),
        _level_05_test_expect_failures(),
        _level_06_test_variables(),
        _level_07_test_multiple_runs(),
        _level_08_test_plan_only(),
        _level_09_test_mock_provider(),
        _level_10_test_override_resource(),
        _level_11_test_override_data(),
        _level_12_test_module_call(),
        _level_13_test_sensitive_output(),
        _level_14_test_provider_config(),
        _level_15_test_complex_assertion(),
        _level_16_test_for_each_resource(),
        _level_17_test_precondition(),
        _level_18_test_setup_teardown(),
    ]
    for lvl in levels:
        write_level(lvl)
    print_done(MODULE, len(levels))
    return len(levels)


# ─────────────────────────────────────────────────────────────────────────────
# Level 1 — test-file-structure
# ─────────────────────────────────────────────────────────────────────────────
def _level_01_test_file_structure():
    return {
        "module": MODULE,
        "slug": "level-1-test-file-structure",
        "mission": {
            "name": "Wrong Block in the Test File",
            "description": "A test file uses `tests {}` as the top-level block, but that is not a valid block in `.tftest.hcl` files. Terraform test files use `run {}` blocks.",
            "objective": "Fix the block type from `tests` to `run` so that `terraform test` passes.",
            "xp": 225,
            "difficulty": "advanced",
            "expected_time": "15m",
            "concepts": [".tftest.hcl structure", "run block", "terraform test"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "hello" {
  content  = "hello"
  filename = "${path.module}/hello.txt"
}

output "greeting" {
  value = "hello"
}
""",
            "tests/main.tftest.hcl": """\
# Wrong: "tests" is not a valid block type — it should be "run"
tests "verify_greeting" {
  assert {
    condition     = output.greeting == "hello"
    error_message = "Greeting output should be 'hello'."
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "hello" {
  content  = "hello"
  filename = "${path.module}/hello.txt"
}

output "greeting" {
  value = "hello"
}
""",
            "tests/main.tftest.hcl": """\
run "verify_greeting" {
  assert {
    condition     = output.greeting == "hello"
    error_message = "Greeting output should be 'hello'."
  }
}
""",
        },
        "validate": VALIDATE_TEST,
        "hints": [
            "Run `terraform test -no-color` and look at the parse error. The block type name is the first keyword on a line in a .tftest.hcl file.",
            "Terraform test files support three top-level block types: `run`, `variables`, and `provider`. There is no `tests` block.",
            "Replace `tests \"verify_greeting\"` with `run \"verify_greeting\"` in the test file.",
        ],
        "debrief": """\
# Wrong Block in the Test File

## What Was Broken
The test file used `tests {}` as the top-level block type. In `.tftest.hcl` files, the correct block
type to declare a test scenario is `run {}`.

## Valid Top-Level Blocks in .tftest.hcl
| Block       | Purpose |
|-------------|---------|
| `run`       | Declare a test scenario (apply or plan + assert) |
| `variables` | Set variable values for all runs in the file |
| `provider`  | Override provider configuration for tests |

## The Fix
```hcl
run "verify_greeting" {
  assert {
    condition     = output.greeting == "hello"
    error_message = "Greeting output should be 'hello'."
  }
}
```

## Why It Matters
The `.tftest.hcl` file format has a strict schema. Using an unknown block type causes an immediate
parse error. Knowing the three valid top-level blocks (`run`, `variables`, `provider`) is the
foundation of Terraform native testing.
""",
        "common_mistakes": """\
# Common Mistakes

- **`tests {}` instead of `run {}`** — the block that defines a test scenario is `run`, not `tests`.
- **Confusing `.tftest.hcl` with regular `.tf` files** — test files have their own block vocabulary.
- **Missing the run block label** — `run "name_here"` requires a quoted label string.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 2 — test-run-command
# ─────────────────────────────────────────────────────────────────────────────
def _level_02_test_run_command():
    return {
        "module": MODULE,
        "slug": "level-2-test-run-command",
        "mission": {
            "name": "Invalid Run Command",
            "description": "A `run` block sets `command = \"apply_all\"`, which is not a valid command value. Only `apply` and `plan` are allowed.",
            "objective": "Fix the command value so that `terraform test` passes.",
            "xp": 225,
            "difficulty": "advanced",
            "expected_time": "15m",
            "concepts": ["run block command values", "terraform test", "apply vs plan"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "configured"
  filename = "${path.module}/config.txt"
}

output "status" {
  value = "configured"
}
""",
            "tests/main.tftest.hcl": """\
run "check_config" {
  # "apply_all" is not a valid command — only "apply" or "plan" are accepted
  command = "apply_all"

  assert {
    condition     = output.status == "configured"
    error_message = "Status should be 'configured'."
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "configured"
  filename = "${path.module}/config.txt"
}

output "status" {
  value = "configured"
}
""",
            "tests/main.tftest.hcl": """\
run "check_config" {
  command = "apply"

  assert {
    condition     = output.status == "configured"
    error_message = "Status should be 'configured'."
  }
}
""",
        },
        "validate": VALIDATE_TEST,
        "hints": [
            "The error from `terraform test` will say the value for `command` is invalid. Check what values are actually permitted.",
            "The `command` argument inside a `run` block accepts exactly two values: `\"apply\"` (the default) and `\"plan\"`.",
            "Change `command = \"apply_all\"` to `command = \"apply\"`.",
        ],
        "debrief": """\
# Invalid Run Command

## What Was Broken
The `run` block set `command = "apply_all"`, which is not a recognized value. Terraform only accepts
`"apply"` or `"plan"` for the `command` argument.

## Command Behaviour
| `command`  | What Terraform does during the test |
|------------|-------------------------------------|
| `"apply"`  | Runs a full apply; resources exist in ephemeral test state; asserts run after apply. |
| `"plan"`   | Only plans; no resources created; asserts run against planned values (unknowns may apply). |

The default when `command` is omitted is `"apply"`.

## Why It Matters
Choosing the right command matters for test accuracy. Using `plan` is faster but some output values
are unknown until apply. Use `apply` when you need to assert against concrete values.
""",
        "common_mistakes": """\
# Common Mistakes

- **`apply_all`, `destroy`, `refresh`** — none of these are valid `command` values.
- **Omitting `command`** — perfectly fine; it defaults to `"apply"`.
- **Using `command = "plan"` then asserting applied resource attributes** — plan-time values are
  often unknown, so assertions on concrete values will fail.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 3 — test-assert-basic
# ─────────────────────────────────────────────────────────────────────────────
def _level_03_test_assert_basic():
    return {
        "module": MODULE,
        "slug": "level-3-test-assert-basic",
        "mission": {
            "name": "Wrong Expected Value in Assert",
            "description": "The test asserts that `output.result == \"wrong_value\"`, but the actual output is `\"correct_value\"`. The assertion always fails.",
            "objective": "Fix the `assert` condition so it matches the actual output and `terraform test` passes.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["assert block", "condition expression", "output values in tests"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
output "result" {
  value = "correct_value"
}
""",
            "tests/main.tftest.hcl": """\
run "check_result" {
  command = "apply"

  assert {
    # The expected value is wrong — output.result is actually "correct_value"
    condition     = output.result == "wrong_value"
    error_message = "Result should equal the expected application value."
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
output "result" {
  value = "correct_value"
}
""",
            "tests/main.tftest.hcl": """\
run "check_result" {
  command = "apply"

  assert {
    condition     = output.result == "correct_value"
    error_message = "Result should equal the expected application value."
  }
}
""",
        },
        "validate": VALIDATE_TEST,
        "hints": [
            "Run `terraform test -no-color`. The output will show the assert failed and print the current value of `output.result`.",
            "Look at `main.tf` — the output block hard-codes the value. Compare that to what the assert expects.",
            "Change `\"wrong_value\"` in the condition to `\"correct_value\"` to match the actual output.",
        ],
        "debrief": """\
# Wrong Expected Value in Assert

## What Was Broken
The `assert` block compared `output.result` against `"wrong_value"`, but the output always produces
`"correct_value"`. The test was set up to always fail.

## Reading Test Failure Output
When an assert fails, `terraform test` prints:
```
Error: Test assertion failed
  on tests/main.tftest.hcl line N, in run "check_result":
  N:     condition = output.result == "wrong_value"
    ├─────────────────
    │ output.result is "correct_value"
```
This tells you the actual value so you can correct the expectation.

## The Fix
```hcl
condition = output.result == "correct_value"
```

## Why It Matters
An assert that always fails (or always passes regardless of configuration) provides no value.
Test conditions must reflect the real intended behaviour of your module.
""",
        "common_mistakes": """\
# Common Mistakes

- **Copy-pasting placeholder expected values** — always verify what the config actually produces.
- **Using `==` on complex types** — for objects/maps, prefer attribute access or `tostring()`.
- **Forgetting `output.` prefix** — inside a `run` block, outputs are accessed as `output.<name>`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 4 — test-assert-message
# ─────────────────────────────────────────────────────────────────────────────
def _level_04_test_assert_message():
    return {
        "module": MODULE,
        "slug": "level-4-test-assert-message",
        "mission": {
            "name": "Empty Error Message",
            "description": "The `assert` block has `error_message = \"\"` — an empty string. Terraform requires a non-empty error message in every assert.",
            "objective": "Add a meaningful error message so the assert is valid and `terraform test` passes.",
            "xp": 225,
            "difficulty": "advanced",
            "expected_time": "15m",
            "concepts": ["assert block", "error_message required", "test documentation"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "instance_count" {
  type    = number
  default = 2
}

output "count" {
  value = var.instance_count
}
""",
            "tests/main.tftest.hcl": """\
run "check_count" {
  command = "apply"

  assert {
    condition     = output.count > 0
    # Empty error_message is not allowed
    error_message = ""
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "instance_count" {
  type    = number
  default = 2
}

output "count" {
  value = var.instance_count
}
""",
            "tests/main.tftest.hcl": """\
run "check_count" {
  command = "apply"

  assert {
    condition     = output.count > 0
    error_message = "Instance count must be greater than zero to ensure at least one instance is running."
  }
}
""",
        },
        "validate": VALIDATE_TEST,
        "hints": [
            "Run `terraform test`. The error will mention that `error_message` must not be empty.",
            "The `error_message` in an `assert` block must contain a non-empty string that explains what went wrong when the condition is false.",
            "Replace `error_message = \"\"` with a descriptive string like `\"Instance count must be greater than zero.\"`",
        ],
        "debrief": """\
# Empty Error Message

## What Was Broken
Terraform's `assert` block requires a non-empty `error_message`. An empty string `""` is rejected
because when the condition fails, the error message is the only context the operator receives.

## Good Error Messages
A useful `error_message` should:
1. Describe what the expected value or state should be.
2. Ideally include the actual value using expression interpolation.
3. Be actionable — tell the reader how to fix the issue.

```hcl
assert {
  condition     = output.count > 0
  error_message = "Instance count must be greater than zero. Got: ${output.count}."
}
```

## Why It Matters
Tests without meaningful error messages slow down debugging. When a CI pipeline reports a test
failure, the `error_message` is the first (and sometimes only) information available.
""",
        "common_mistakes": """\
# Common Mistakes

- **Empty `error_message = ""`** — not allowed; Terraform will reject it.
- **Generic messages like `"assertion failed"`** — technically valid but unhelpful.
- **Not interpolating the actual value** — adding `${output.count}` to the message makes failures
  immediately obvious without re-running in verbose mode.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 5 — test-expect-failures
# ─────────────────────────────────────────────────────────────────────────────
def _level_05_test_expect_failures():
    return {
        "module": MODULE,
        "slug": "level-5-test-expect-failures",
        "mission": {
            "name": "Wrong expect_failures Address",
            "description": "A test uses `expect_failures = [\"var.port\"]` (a string) to confirm a validation error fires, but `expect_failures` requires unquoted references, not strings.",
            "objective": "Correct the `expect_failures` entry to an unquoted reference so `terraform test` confirms the validation failure.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["expect_failures", "variable validation", "test negative path"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "port" {
  type = number
  validation {
    condition     = var.port >= 1024 && var.port <= 65535
    error_message = "Port must be between 1024 and 65535."
  }
}

output "port_value" {
  value = var.port
}
""",
            "tests/main.tftest.hcl": """\
run "test_port_validation" {
  command = "plan"

  variables {
    port = 80  # below minimum — should trigger validation error
  }

  # Wrong: the address is a quoted string, not an unquoted reference
  expect_failures = [
    "var.port",
  ]
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "port" {
  type = number
  validation {
    condition     = var.port >= 1024 && var.port <= 65535
    error_message = "Port must be between 1024 and 65535."
  }
}

output "port_value" {
  value = var.port
}
""",
            "tests/main.tftest.hcl": """\
run "test_port_validation" {
  command = "plan"

  variables {
    port = 80  # below minimum — triggers validation error
  }

  expect_failures = [
    var.port,
  ]
}
""",
        },
        "validate": VALIDATE_TEST,
        "hints": [
            "Run `terraform test`. The error will say the address in `expect_failures` is not valid or is a string rather than a reference.",
            "`expect_failures` takes a list of Terraform *references*, not strings. References are unquoted expressions like `var.port`, not `\"var.port\"`.",
            "Remove the quotes around `var.port` in the `expect_failures` list.",
        ],
        "debrief": """\
# Wrong expect_failures Address

## What Was Broken
The `expect_failures` list contained `"var.port"` — a string literal — instead of the reference
`var.port`. Terraform expects unquoted traversal references, not string addresses.

## expect_failures Syntax
```hcl
expect_failures = [
  var.port,               # variable validation
  resource_type.name,     # resource precondition / postcondition
  data.type.name,         # data source postcondition
]
```

## What expect_failures Does
When a run block includes `expect_failures`, Terraform:
1. Runs the plan/apply as normal.
2. Expects the listed checks to **fail**.
3. Passes the test if they do fail; fails the test if they do not.

This is the correct way to write *negative tests* — tests that confirm invalid inputs are rejected.

## Why It Matters
Negative testing is as important as positive testing. Without it, a broken validation rule
might silently allow bad input into production.
""",
        "common_mistakes": """\
# Common Mistakes

- **Quoting the address** — `"var.port"` is a string, not a reference. Use `var.port` (no quotes).
- **Using `expect_failures` when no failure is expected** — the test will fail if the listed
  checks do NOT fail.
- **Wrong resource address** — use the full `resource_type.resource_name` form.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 6 — test-variables
# ─────────────────────────────────────────────────────────────────────────────
def _level_06_test_variables():
    return {
        "module": MODULE,
        "slug": "level-6-test-variables",
        "mission": {
            "name": "Wrong Type in Test Variable Override",
            "description": "The test file overrides `var.item_count` with `\"three\"` (a string), but the variable is declared as `type = number`. Terraform rejects the type mismatch.",
            "objective": "Fix the variable override so it passes a number and `terraform test` succeeds.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["test variable overrides", "type constraints", "variables block in tests"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "item_count" {
  type    = number
  default = 1
}

output "item_count" {
  value = var.item_count
}
""",
            "tests/main.tftest.hcl": """\
run "verify_count" {
  command = "apply"

  variables {
    # Wrong: "three" is a string but var.item_count expects a number
    item_count = "three"
  }

  assert {
    condition     = output.item_count == 3
    error_message = "Item count should be 3."
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "item_count" {
  type    = number
  default = 1
}

output "item_count" {
  value = var.item_count
}
""",
            "tests/main.tftest.hcl": """\
run "verify_count" {
  command = "apply"

  variables {
    item_count = 3
  }

  assert {
    condition     = output.item_count == 3
    error_message = "Item count should be 3."
  }
}
""",
        },
        "validate": VALIDATE_TEST,
        "hints": [
            "Run `terraform test`. The error will mention a type mismatch for `var.item_count`.",
            "Inside a `variables {}` block in a test file, values are HCL expressions — use `3` (a number literal) not `\"three\"` (a string literal).",
            "Change `item_count = \"three\"` to `item_count = 3`.",
        ],
        "debrief": """\
# Wrong Type in Test Variable Override

## What Was Broken
The `variables` block inside the `run` block set `item_count = "three"`, which is a string. The
variable declaration in `main.tf` requires `type = number`. Terraform cannot coerce `"three"`
to a number.

## Type Coercion in Tests
Terraform *can* coerce `"3"` (a numeric string) to `number`, but semantic strings like `"three"`
have no numeric representation and always fail.

## Variables Block in Tests
```hcl
run "my_test" {
  variables {
    item_count    = 3          # number literal — correct
    environment   = "staging"  # string literal
    enable_flag   = true       # boolean literal
    tags          = { team = "ops" }  # map literal
  }
}
```

## Why It Matters
Test variable overrides follow the same type rules as regular variable assignments. Understanding
HCL types prevents subtle bugs where the test itself is misconfigured rather than the module.
""",
        "common_mistakes": """\
# Common Mistakes

- **Wrapping numbers in quotes** — `"3"` is a string; `3` is a number.
- **Using word-numbers** — `"three"`, `"one"`, etc. cannot be coerced to numbers.
- **Forgetting booleans** — `"true"` is a string; `true` (no quotes) is a boolean.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 7 — test-multiple-runs
# ─────────────────────────────────────────────────────────────────────────────
def _level_07_test_multiple_runs():
    return {
        "module": MODULE,
        "slug": "level-7-test-multiple-runs",
        "mission": {
            "name": "Wrong Output Reference Across Run Blocks",
            "description": "The second `run` block references `run.first.output.file_path`, which is not valid syntax. Outputs from previous runs are accessible directly as `output.<name>`.",
            "objective": "Fix the output reference so `terraform test` passes.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["multiple run blocks", "output references", "state sharing in tests"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "filename" {
  type    = string
  default = "output.txt"
}

resource "local_file" "out" {
  content  = "data"
  filename = "${path.module}/${var.filename}"
}

output "file_path" {
  value = local_file.out.filename
}
""",
            "tests/main.tftest.hcl": """\
run "first" {
  command = "apply"
}

run "second" {
  command = "apply"

  assert {
    # Wrong: run.first.output.file_path is not valid — use output.file_path directly
    condition     = run.first.output.file_path != ""
    error_message = "File path should not be empty."
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "filename" {
  type    = string
  default = "output.txt"
}

resource "local_file" "out" {
  content  = "data"
  filename = "${path.module}/${var.filename}"
}

output "file_path" {
  value = local_file.out.filename
}
""",
            "tests/main.tftest.hcl": """\
run "first" {
  command = "apply"
}

run "second" {
  command = "apply"

  assert {
    condition     = output.file_path != ""
    error_message = "File path should not be empty."
  }
}
""",
        },
        "validate": VALIDATE_TEST,
        "hints": [
            "Run `terraform test`. The error will say `run.first` is not a valid reference or that the attribute does not exist.",
            "In Terraform test files, outputs are shared across `run` blocks via the module's state. You access the current state's outputs simply as `output.<name>`, not via a run-block prefix.",
            "Replace `run.first.output.file_path` with `output.file_path`.",
        ],
        "debrief": """\
# Wrong Output Reference Across Run Blocks

## What Was Broken
The assertion used `run.first.output.file_path` — a non-existent reference syntax. In Terraform
native tests, multiple `run` blocks within a single test file share the same ephemeral state.
Outputs are accessed using the flat `output.<name>` syntax regardless of which `run` block
produced the resource.

## How State is Shared Between Run Blocks
```
run "first"  →  applies resources  →  state contains local_file.out
run "second" →  operates on same state  →  output.file_path is still accessible
```

## Why There Is No run.X.output Syntax
Terraform tests do not expose per-run namespaced outputs. If you need to test a transition
(apply → destroy → re-apply), each step still reads from the common test state.

## Why It Matters
Understanding how state flows through multiple `run` blocks is essential to writing correct
multi-step integration tests.
""",
        "common_mistakes": """\
# Common Mistakes

- **`run.<name>.output.<attr>`** — this namespace does not exist; use `output.<attr>` directly.
- **Assuming run blocks have isolated state** — they share the same test state by default.
- **Forgetting that prior runs affect state** — resources created in `run "first"` persist
  in state for `run "second"` unless explicitly destroyed.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 8 — test-plan-only
# ─────────────────────────────────────────────────────────────────────────────
def _level_08_test_plan_only():
    return {
        "module": MODULE,
        "slug": "level-8-test-plan-only",
        "mission": {
            "name": "Asserting Applied Values During Plan",
            "description": "A `run` block uses `command = \"plan\"` but asserts an output value that is only known after apply. During plan, the output is `(known after apply)` and the assertion always fails.",
            "objective": "Change the command to `\"apply\"` so the output value is known and the assertion can succeed.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["plan vs apply in tests", "known after apply", "test command selection"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "data" {
  content  = "important data"
  filename = "${path.module}/data.txt"
}

output "file_id" {
  value = local_file.data.id
}
""",
            "tests/main.tftest.hcl": """\
run "verify_file" {
  # Using plan but asserting a value only known after apply
  command = "plan"

  assert {
    condition     = output.file_id != ""
    error_message = "File ID should not be empty after creation."
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "data" {
  content  = "important data"
  filename = "${path.module}/data.txt"
}

output "file_id" {
  value = local_file.data.id
}
""",
            "tests/main.tftest.hcl": """\
run "verify_file" {
  command = "apply"

  assert {
    condition     = output.file_id != ""
    error_message = "File ID should not be empty after creation."
  }
}
""",
        },
        "validate": VALIDATE_TEST,
        "hints": [
            "Run `terraform test`. The error will indicate the condition references an unknown value, or `output.file_id` is null/unknown during plan.",
            "Resource-computed attributes like `id` are only available after the resource is actually created. During `plan`, they are `(known after apply)`.",
            "Change `command = \"plan\"` to `command = \"apply\"` so the resource is created and its `id` is available for assertion.",
        ],
        "debrief": """\
# Asserting Applied Values During Plan

## What Was Broken
The `run` block used `command = "plan"`, but the assertion checked `output.file_id` — an attribute
that is only computed after the resource is applied. During plan, this value is unknown, causing
the assertion to fail.

## Plan vs Apply in Tests

| Attribute type              | Available during `plan`? | Available during `apply`? |
|-----------------------------|--------------------------|---------------------------|
| Input variables             | Yes                       | Yes                       |
| Static locals               | Yes                       | Yes                       |
| Resource-computed attributes | No (unknown)             | Yes                       |
| Output referencing computed  | No                       | Yes                       |

## When to Use Each
- **`command = "plan"`**: Test variable validation, structural checks, or that no changes are
  planned after an idempotent apply.
- **`command = "apply"`**: Test actual resource creation, computed attribute values, and
  integration between resources.

## Why It Matters
Using the wrong command leads to flaky tests that fail on computed values. Choosing `plan` when
you need post-apply values is a common early mistake in Terraform testing.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `plan` to assert computed IDs or ARNs** — these are only known after apply.
- **Using `apply` for every test** — prefer `plan` when you only need structural validation;
  it is faster and does not create real resources.
- **Expecting `plan` assertions on `count` or `for_each` expansions** — these can also be
  unknown during plan if they depend on computed values.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 9 — test-mock-provider
# ─────────────────────────────────────────────────────────────────────────────
def _level_09_test_mock_provider():
    return {
        "module": MODULE,
        "slug": "level-9-test-mock-provider",
        "mission": {
            "name": "Incomplete Mock Provider",
            "description": "A test uses `mock_provider \"local\" {}` but does not define a `mock_resource` for `local_file`. Terraform cannot mock the resource schema and the test fails.",
            "objective": "Add a `mock_resource \"local_file\"` with default values so `terraform test` passes.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["mock_provider", "mock_resource", "provider mocking in tests"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "app" {
  content  = "mock content"
  filename = "/tmp/app.txt"
}

output "filename" {
  value = local_file.app.filename
}
""",
            "tests/main.tftest.hcl": """\
# Mock provider declared but no mock_resource defined for local_file
mock_provider "local" {}

run "verify_mock" {
  command = "apply"

  assert {
    condition     = output.filename == "/tmp/app.txt"
    error_message = "Filename should be /tmp/app.txt."
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "app" {
  content  = "mock content"
  filename = "/tmp/app.txt"
}

output "filename" {
  value = local_file.app.filename
}
""",
            "tests/main.tftest.hcl": """\
mock_provider "local" {
  mock_resource "local_file" {
    defaults = {
      filename = "/tmp/test.txt"
    }
  }
}

run "verify_mock" {
  command = "apply"

  assert {
    condition     = output.filename == "/tmp/app.txt"
    error_message = "Filename should be /tmp/app.txt."
  }
}
""",
        },
        "validate": VALIDATE_TEST,
        "hints": [
            "Run `terraform test`. The error will mention that the mock provider cannot handle the `local_file` resource because no schema defaults are defined.",
            "Inside a `mock_provider` block, you define `mock_resource` blocks for each resource type you want to mock. Each `mock_resource` has a `defaults` map for computed attribute values.",
            "Add `mock_resource \"local_file\" { defaults = { filename = \"/tmp/test.txt\" } }` inside the `mock_provider \"local\" {}` block.",
        ],
        "debrief": """\
# Incomplete Mock Provider

## What Was Broken
The `mock_provider "local" {}` block was empty. When Terraform applies with a mock provider,
it needs to know how to generate default values for the resource's computed attributes. Without
a `mock_resource` definition, the mock cannot satisfy the schema.

## mock_provider Structure
```hcl
mock_provider "local" {
  mock_resource "local_file" {
    defaults = {
      filename = "/tmp/test.txt"
      id       = "mock-id"
    }
  }
  mock_data "local_file" {
    defaults = {
      content = "mocked file content"
    }
  }
}
```

## When to Use Mock Providers
- Tests that should not create real infrastructure.
- Unit-testing module logic without provider API calls.
- CI pipelines without cloud credentials.

## Why It Matters
Mock providers allow fast, isolated tests. Understanding how to configure them properly —
including `mock_resource` defaults — is essential for effective Terraform unit testing.
""",
        "common_mistakes": """\
# Common Mistakes

- **Empty `mock_provider` block** — you must define `mock_resource` for each resource type used.
- **Forgetting `mock_data` blocks** — data sources also need mocking if used in the config.
- **Setting `defaults` for non-computed attributes** — `defaults` are for computed (unknown at plan)
  attributes; required input attributes must still be set in the resource block.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 10 — test-override-resource
# ─────────────────────────────────────────────────────────────────────────────
def _level_10_test_override_resource():
    return {
        "module": MODULE,
        "slug": "level-10-test-override-resource",
        "mission": {
            "name": "Wrong Resource Address in override_resource",
            "description": "`override_resource { target = local_file.wrong_name }` references a resource that does not exist. Fix the address to match the actual resource.",
            "objective": "Correct the `target` address in `override_resource` so `terraform test` passes.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["override_resource", "resource addressing", "test overrides"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "production config"
  filename = "${path.module}/config.txt"
}

output "config_path" {
  value = local_file.config.filename
}
""",
            "tests/main.tftest.hcl": """\
run "test_config" {
  command = "apply"

  # Wrong resource address — actual resource is local_file.config, not local_file.wrong_name
  override_resource {
    target = local_file.wrong_name
    values = {
      filename = "/tmp/override_config.txt"
    }
  }

  assert {
    condition     = output.config_path != ""
    error_message = "Config path should not be empty."
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "production config"
  filename = "${path.module}/config.txt"
}

output "config_path" {
  value = local_file.config.filename
}
""",
            "tests/main.tftest.hcl": """\
run "test_config" {
  command = "apply"

  override_resource {
    target = local_file.config
    values = {
      filename = "/tmp/override_config.txt"
    }
  }

  assert {
    condition     = output.config_path != ""
    error_message = "Config path should not be empty."
  }
}
""",
        },
        "validate": VALIDATE_TEST,
        "hints": [
            "Run `terraform test`. The error will say the target resource `local_file.wrong_name` does not exist in the configuration.",
            "Open `main.tf` and find the actual resource name. The format is `<resource_type>.<resource_name>` — check what comes after `resource \"local_file\"`.",
            "Change `target = local_file.wrong_name` to `target = local_file.config`.",
        ],
        "debrief": """\
# Wrong Resource Address in override_resource

## What Was Broken
The `override_resource` block targeted `local_file.wrong_name`, but the actual resource in the
configuration is `local_file.config`. Terraform could not find the target and rejected the override.

## override_resource Syntax
```hcl
override_resource {
  target = resource_type.resource_name  # must match exactly
  values = {
    computed_attr = "override_value"
  }
}
```

## What override_resource Does
`override_resource` replaces the provider's handling of a specific resource during a test. Instead
of calling the real provider CRUD, Terraform uses the `values` you specify. This is useful when:
- You want to test downstream logic without creating real infrastructure.
- The resource creation is slow or requires credentials you don't have in CI.

## Why It Matters
Precise resource addressing is fundamental. A typo in the target silently fails to override the
intended resource. Always cross-reference the target address with the actual resource declarations.
""",
        "common_mistakes": """\
# Common Mistakes

- **Typos in the resource name** — `local_file.config` vs `local_file.configs` are different.
- **Wrong resource type** — `local_sensitive_file.config` is different from `local_file.config`.
- **Using quoted strings** — `target = "local_file.config"` is wrong; use an unquoted reference.
- **Targeting module resources** — for child module resources use `module.name.resource_type.name`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 11 — test-override-data
# ─────────────────────────────────────────────────────────────────────────────
def _level_11_test_override_data():
    return {
        "module": MODULE,
        "slug": "level-11-test-override-data",
        "mission": {
            "name": "Wrong Data Source Address in override_data",
            "description": "`override_data { target = data.local_file.wrong }` uses an incorrect data source address. Fix it to match the actual data source.",
            "objective": "Correct the `target` address in `override_data` so `terraform test` passes.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["override_data", "data source addressing", "test data overrides"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
data "local_file" "settings" {
  filename = "${path.module}/settings.txt"
}

output "settings_content" {
  value = data.local_file.settings.content
}
""",
            "tests/main.tftest.hcl": """\
run "test_settings" {
  command = "plan"

  # Wrong: actual data source is data.local_file.settings, not data.local_file.wrong
  override_data {
    target = data.local_file.wrong
    values = {
      content = "mocked settings content"
    }
  }

  assert {
    condition     = output.settings_content != ""
    error_message = "Settings content should not be empty."
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
data "local_file" "settings" {
  filename = "${path.module}/settings.txt"
}

output "settings_content" {
  value = data.local_file.settings.content
}
""",
            "tests/main.tftest.hcl": """\
run "test_settings" {
  command = "plan"

  override_data {
    target = data.local_file.settings
    values = {
      content = "mocked settings content"
    }
  }

  assert {
    condition     = output.settings_content != ""
    error_message = "Settings content should not be empty."
  }
}
""",
        },
        "validate": VALIDATE_TEST,
        "hints": [
            "Run `terraform test`. The error says the data source `data.local_file.wrong` does not exist in the configuration.",
            "Check `main.tf` for the actual data source declaration. The format is `data.<type>.<name>`.",
            "Change `target = data.local_file.wrong` to `target = data.local_file.settings`.",
        ],
        "debrief": """\
# Wrong Data Source Address in override_data

## What Was Broken
The `override_data` block referenced `data.local_file.wrong`, but the actual data source in the
configuration is `data.local_file.settings`. Terraform rejected the unknown target.

## override_data Syntax
```hcl
override_data {
  target = data.data_type.data_name  # must match exactly
  values = {
    attribute = "mocked_value"
  }
}
```

## override_data vs override_resource
| Block               | Targets          | Use Case |
|---------------------|------------------|----------|
| `override_resource` | Managed resources | Replace resource CRUD |
| `override_data`     | Data sources     | Replace data source reads |

## Why It Matters
Data sources often read from external systems (APIs, cloud services). `override_data` lets you
inject known values without external calls, making tests deterministic and offline-capable.
""",
        "common_mistakes": """\
# Common Mistakes

- **Forgetting the `data.` prefix** — `data.local_file.settings` requires all three parts.
- **Using quotes** — `target = "data.local_file.settings"` is a string, not a reference.
- **Mixing up `override_data` and `override_resource`** — data sources and managed resources have
  separate override block types.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 12 — test-module-call
# ─────────────────────────────────────────────────────────────────────────────
def _level_12_test_module_call():
    return {
        "module": MODULE,
        "slug": "level-12-test-module-call",
        "mission": {
            "name": "Wrong Module Source Path in Test",
            "description": "The main config calls a local module with `source = \"../wrong/path\"`. The module does not exist at that path, so `terraform test` fails.",
            "objective": "Fix the module source path so `terraform test` can find the child module.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["module source", "local module paths", "module testing"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Wrong module source path
module "greeter" {
  source = "../wrong/path"
  name   = "TerraformMissions"
}

output "greeting" {
  value = module.greeter.greeting
}
""",
            "modules/greeter/main.tf": """\
variable "name" {
  type = string
}

output "greeting" {
  value = "Hello, ${var.name}!"
}
""",
            "modules/greeter/terraform.tf": LOCAL_ONLY_TF,
            "tests/main.tftest.hcl": """\
run "test_greeting" {
  command = "apply"

  assert {
    condition     = output.greeting == "Hello, TerraformMissions!"
    error_message = "Greeting should include the provided name."
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
module "greeter" {
  source = "./modules/greeter"
  name   = "TerraformMissions"
}

output "greeting" {
  value = module.greeter.greeting
}
""",
            "modules/greeter/main.tf": """\
variable "name" {
  type = string
}

output "greeting" {
  value = "Hello, ${var.name}!"
}
""",
            "modules/greeter/terraform.tf": LOCAL_ONLY_TF,
            "tests/main.tftest.hcl": """\
run "test_greeting" {
  command = "apply"

  assert {
    condition     = output.greeting == "Hello, TerraformMissions!"
    error_message = "Greeting should include the provided name."
  }
}
""",
        },
        "validate": VALIDATE_TEST,
        "hints": [
            "Run `terraform test`. The error says it cannot find the module at `../wrong/path`. Check where the module files actually live relative to `main.tf`.",
            "Look at the directory structure. The module files are in `modules/greeter/`. The source path in `main.tf` should be relative to the config root.",
            "Change `source = \"../wrong/path\"` to `source = \"./modules/greeter\"`.",
        ],
        "debrief": """\
# Wrong Module Source Path in Test

## What Was Broken
The `module "greeter"` block used `source = "../wrong/path"`, which does not contain a valid
Terraform module. The correct path is `"./modules/greeter"` relative to the root config.

## Local Module Path Rules
- Paths starting with `./` or `../` are treated as local filesystem paths.
- The path is relative to the calling configuration file (not the working directory).
- After changing a `source` path, run `terraform init` to update the module cache.

## Module Source Types
| Format                    | Type |
|---------------------------|------|
| `"./modules/foo"`         | Local path |
| `"hashicorp/consul/aws"`  | Terraform Registry |
| `"git::https://..."`      | Git URL |
| `"github.com/..."`        | GitHub shorthand |

## Why It Matters
Incorrect module source paths are a frequent cause of init failures. Understanding relative vs.
absolute paths and the module cache is essential for working with modular Terraform codebases.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `..` when the module is a subdirectory** — if the module is *inside* the project, use
  `./subdir`, not `../subdir`.
- **Forgetting `terraform init` after changing source** — the module cache must be updated.
- **Using absolute paths** — these work locally but break in CI. Always use relative paths.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 13 — test-sensitive-output
# ─────────────────────────────────────────────────────────────────────────────
def _level_13_test_sensitive_output():
    return {
        "module": MODULE,
        "slug": "level-13-test-sensitive-output",
        "mission": {
            "name": "Asserting a Sensitive Output Value",
            "description": "The test tries to compare a sensitive output directly: `condition = output.password == \"secret123\"`. Terraform refuses to evaluate sensitive values in equality conditions. Fix the assertion to check only that the output is non-empty.",
            "objective": "Rewrite the assert condition to avoid direct comparison of the sensitive value.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["sensitive outputs in tests", "sensitive values", "assertion design"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "password" {
  type      = string
  sensitive = true
  default   = "secret123"
}

output "password" {
  value     = var.password
  sensitive = true
}
""",
            "tests/main.tftest.hcl": """\
run "check_password" {
  command = "apply"

  assert {
    # Cannot directly compare sensitive values in conditions
    condition     = output.password == "secret123"
    error_message = "Password output should equal the input."
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "password" {
  type      = string
  sensitive = true
  default   = "secret123"
}

output "password" {
  value     = var.password
  sensitive = true
}
""",
            "tests/main.tftest.hcl": """\
run "check_password" {
  command = "apply"

  assert {
    condition     = output.password != ""
    error_message = "Password output should not be empty."
  }
}
""",
        },
        "validate": VALIDATE_TEST,
        "hints": [
            "Run `terraform test`. Terraform will error because the sensitive output cannot be used in a condition that reveals its value.",
            "You cannot compare sensitive outputs directly in test conditions. Instead, test structural properties: is it non-empty? Does it have the right length? Use `length(output.password) > 0`.",
            "Change the condition to `output.password != \"\"` or `length(output.password) >= 8`.",
        ],
        "debrief": """\
# Asserting a Sensitive Output Value

## What Was Broken
The `assert` condition used `output.password == "secret123"`, which requires Terraform to evaluate
a sensitive value and expose it in a comparison. Terraform blocks this to prevent sensitive data
from appearing in logs or plan output.

## Testing Sensitive Outputs Safely

Instead of testing the exact value, test structural properties:
```hcl
assert {
  condition     = output.password != ""
  error_message = "Password should not be empty."
}

assert {
  condition     = length(output.password) >= 16
  error_message = "Password should be at least 16 characters."
}
```

## Why Terraform Blocks It
Terraform's sensitive value system ensures secrets do not appear in:
- CLI output
- Plan files
- State file diffs shown in logs
- Test assertion output

## Why It Matters
Security-aware test design avoids accidentally printing secrets in CI/CD logs. Always test
sensitive outputs for structural correctness (non-empty, minimum length, format) rather than
exact value equality.
""",
        "common_mistakes": """\
# Common Mistakes

- **Direct equality on sensitive values** — always fails; use structural checks instead.
- **Using `nonsensitive()` just to make the assertion work** — this defeats the security model.
- **Not testing sensitive outputs at all** — structural tests still validate that the value was
  produced and meets minimum requirements.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 14 — test-provider-config
# ─────────────────────────────────────────────────────────────────────────────
def _level_14_test_provider_config():
    return {
        "module": MODULE,
        "slug": "level-14-test-provider-config",
        "mission": {
            "name": "Duplicate Provider Configuration in Test",
            "description": "The test file configures the `local` provider twice using `provider` blocks. Terraform rejects duplicate provider configurations. Remove the duplicate.",
            "objective": "Remove the duplicate `provider` block so `terraform test` passes.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["provider config in tests", "provider block", "duplicate configuration"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "report" {
  content  = "report data"
  filename = "${path.module}/report.txt"
}

output "report_path" {
  value = local_file.report.filename
}
""",
            "tests/main.tftest.hcl": """\
# Provider configured once
provider "local" {}

# Provider configured again — duplicate causes an error
provider "local" {}

run "check_report" {
  command = "apply"

  assert {
    condition     = output.report_path != ""
    error_message = "Report path should not be empty."
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "report" {
  content  = "report data"
  filename = "${path.module}/report.txt"
}

output "report_path" {
  value = local_file.report.filename
}
""",
            "tests/main.tftest.hcl": """\
provider "local" {}

run "check_report" {
  command = "apply"

  assert {
    condition     = output.report_path != ""
    error_message = "Report path should not be empty."
  }
}
""",
        },
        "validate": VALIDATE_TEST,
        "hints": [
            "Run `terraform test`. The error will mention a duplicate provider configuration for `local`.",
            "Count the `provider \"local\" {}` blocks in the test file. Each provider can only be configured once (unless you use aliases).",
            "Delete one of the two `provider \"local\" {}` blocks.",
        ],
        "debrief": """\
# Duplicate Provider Configuration in Test

## What Was Broken
The test file declared two `provider "local" {}` blocks without aliases. Terraform only allows one
configuration per provider per alias. Duplicates cause a parse or validation error.

## Provider Blocks in Test Files
Test file `provider` blocks override the providers used during that test run. They follow the same
rules as provider configurations in `.tf` files:
- One configuration per provider name (without alias).
- Multiple configurations allowed if each has a unique `alias`.

## When You Need Multiple Provider Configs
```hcl
provider "aws" {
  alias  = "us-east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "eu-west"
  region = "eu-west-1"
}
```

## Why It Matters
Duplicate provider configurations are a sign of copy-paste errors. In test files, they often
appear when tests are assembled from snippets without checking for existing provider blocks.
""",
        "common_mistakes": """\
# Common Mistakes

- **Copying provider blocks from multiple test files without deduplication**.
- **Forgetting that `provider` blocks in test files override, not augment, the root config**.
- **Not using aliases when two configs for the same provider are genuinely needed**.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 15 — test-complex-assertion
# ─────────────────────────────────────────────────────────────────────────────
def _level_15_test_complex_assertion():
    return {
        "module": MODULE,
        "slug": "level-15-test-complex-assertion",
        "mission": {
            "name": "Compound Assertion Always False",
            "description": "The assert uses `condition = output.a == \"x\" && output.b == \"wrong\"`. The second part is always false because `output.b` is `\"y\"`, not `\"wrong\"`. Fix both parts of the compound condition.",
            "objective": "Correct the compound assertion so it accurately tests both outputs and `terraform test` passes.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["compound assertions", "logical operators in conditions", "assertion correctness"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
output "a" {
  value = "x"
}

output "b" {
  value = "y"
}
""",
            "tests/main.tftest.hcl": """\
run "check_outputs" {
  command = "apply"

  assert {
    # output.b is "y" but we're checking for "wrong" — second clause always fails
    condition     = output.a == "x" && output.b == "wrong"
    error_message = "Both outputs should match expected values."
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
output "a" {
  value = "x"
}

output "b" {
  value = "y"
}
""",
            "tests/main.tftest.hcl": """\
run "check_outputs" {
  command = "apply"

  assert {
    condition     = output.a == "x" && output.b == "y"
    error_message = "Both outputs should match expected values: a='x', b='y'."
  }
}
""",
        },
        "validate": VALIDATE_TEST,
        "hints": [
            "Run `terraform test`. The failure output will show you the current values of `output.a` and `output.b`.",
            "Check `main.tf` to see what each output actually produces. The `&&` condition requires *both* parts to be true.",
            "Change `output.b == \"wrong\"` to `output.b == \"y\"` to match the actual output value.",
        ],
        "debrief": """\
# Compound Assertion Always False

## What Was Broken
The compound condition `output.a == "x" && output.b == "wrong"` always evaluates to `false`
because `output.b` produces `"y"`, not `"wrong"`. A condition that can never be true is a
broken test.

## Debugging Compound Assertions
When a compound `&&` condition fails, check each part independently. Terraform's failure output
shows the evaluated values, which makes it easy to identify which part fails.

## Best Practices for Compound Assertions
Consider splitting compound assertions into individual `assert` blocks:
```hcl
assert {
  condition     = output.a == "x"
  error_message = "Output a should be 'x'."
}

assert {
  condition     = output.b == "y"
  error_message = "Output b should be 'y'."
}
```

This gives more precise failure messages. A single `&&` condition only tells you that *something*
was wrong, not which specific output failed.

## Why It Matters
Compound assertions that always fail (or always pass) give false confidence. Every condition
in a test should be reachable in both its true and false state.
""",
        "common_mistakes": """\
# Common Mistakes

- **Mixing up `&&` and `||`** — `||` (OR) is true if either part is true; `&&` (AND) requires both.
- **Asserting wrong expected values** — always verify expected values by reading the config.
- **Over-consolidating assertions** — prefer multiple focused `assert` blocks over one complex one.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 16 — test-for-each-resource
# ─────────────────────────────────────────────────────────────────────────────
def _level_16_test_for_each_resource():
    return {
        "module": MODULE,
        "slug": "level-16-test-for-each-resource",
        "mission": {
            "name": "Wrong Key in for_each Output Assertion",
            "description": "The test asserts `output.files[\"wrong_key\"].content` but the `for_each` map uses keys `\"alpha\"` and `\"beta\"`. Fix the key in the assertion.",
            "objective": "Use the correct map key in the assertion so `terraform test` passes.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["for_each in tests", "map output assertions", "collection access"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "files" {
  type = map(string)
  default = {
    alpha = "content-alpha"
    beta  = "content-beta"
  }
}

resource "local_file" "docs" {
  for_each = var.files
  content  = each.value
  filename = "${path.module}/${each.key}.txt"
}

output "files" {
  value = { for k, v in local_file.docs : k => v }
}
""",
            "tests/main.tftest.hcl": """\
run "check_files" {
  command = "apply"

  assert {
    # "wrong_key" does not exist — actual keys are "alpha" and "beta"
    condition     = output.files["wrong_key"].content == "content-alpha"
    error_message = "Alpha file should have content-alpha."
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "files" {
  type = map(string)
  default = {
    alpha = "content-alpha"
    beta  = "content-beta"
  }
}

resource "local_file" "docs" {
  for_each = var.files
  content  = each.value
  filename = "${path.module}/${each.key}.txt"
}

output "files" {
  value = { for k, v in local_file.docs : k => v }
}
""",
            "tests/main.tftest.hcl": """\
run "check_files" {
  command = "apply"

  assert {
    condition     = output.files["alpha"].content == "content-alpha"
    error_message = "Alpha file should have content-alpha."
  }
}
""",
        },
        "validate": VALIDATE_TEST,
        "hints": [
            "Run `terraform test`. The error will say the key `\"wrong_key\"` does not exist in the map.",
            "Check `main.tf` — the `for_each` map uses string keys. Look at the `default` value of `var.files` to see the available keys.",
            "Change `output.files[\"wrong_key\"]` to `output.files[\"alpha\"]`.",
        ],
        "debrief": """\
# Wrong Key in for_each Output Assertion

## What Was Broken
The assertion accessed `output.files["wrong_key"]`, but the `for_each` map only has keys
`"alpha"` and `"beta"`. Accessing a non-existent map key causes the test to fail.

## Accessing for_each Outputs
When a resource uses `for_each`, its output (if exported as a map) is indexed by the same keys:
```hcl
output.files["alpha"].content   # correct key
output.files["beta"].filename   # correct key
output.files["wrong_key"]       # error: key does not exist
```

## Checking Available Keys in Tests
If keys are dynamic, use `keys(output.files)` or `contains(keys(output.files), "alpha")` in
conditions rather than hard-coding a key that might not exist.

## Why It Matters
`for_each` resources produce collection outputs that require correct key access. Mistakes in key
names are common when renaming resources or changing input maps.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using the resource name instead of the for_each key** — the key is from the map, not the
  resource type name.
- **Forgetting quotes around string keys** — `output.files[alpha]` is a reference, not a key
  lookup; use `output.files["alpha"]`.
- **Assuming numeric indices** — `for_each` maps use string keys, not sequential numbers.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 17 — test-precondition
# ─────────────────────────────────────────────────────────────────────────────
def _level_17_test_precondition():
    return {
        "module": MODULE,
        "slug": "level-17-test-precondition",
        "mission": {
            "name": "Wrong expect_failures Target for Precondition",
            "description": "`expect_failures = [local_file.config]` targets the resource but the validation check is on `var.filename`. Fix the target to `var.filename`.",
            "objective": "Correct the `expect_failures` target so it points to the variable with the validation and `terraform test` passes.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["precondition expect_failures", "variable vs resource checks", "negative testing"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "filename" {
  type = string
  validation {
    condition     = length(var.filename) > 0
    error_message = "Filename must not be empty."
  }
}

resource "local_file" "config" {
  content  = "data"
  filename = "${path.module}/${var.filename}"
}
""",
            "tests/main.tftest.hcl": """\
run "test_empty_filename" {
  command = "plan"

  variables {
    filename = ""  # empty — triggers validation error on var.filename
  }

  # Wrong: the check is on var.filename, not on the resource
  expect_failures = [
    local_file.config,
  ]
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "filename" {
  type = string
  validation {
    condition     = length(var.filename) > 0
    error_message = "Filename must not be empty."
  }
}

resource "local_file" "config" {
  content  = "data"
  filename = "${path.module}/${var.filename}"
}
""",
            "tests/main.tftest.hcl": """\
run "test_empty_filename" {
  command = "plan"

  variables {
    filename = ""  # empty — triggers validation error on var.filename
  }

  expect_failures = [
    var.filename,
  ]
}
""",
        },
        "validate": VALIDATE_TEST,
        "hints": [
            "Run `terraform test`. Terraform may report that `local_file.config` is not expected to fail, or that the expected failure was not produced by the right check.",
            "The `validation` block is on `variable \"filename\"`, not on the `local_file.config` resource. `expect_failures` must reference where the check lives.",
            "Change `local_file.config` to `var.filename` in the `expect_failures` list.",
        ],
        "debrief": """\
# Wrong expect_failures Target for Precondition

## What Was Broken
The `expect_failures` list referenced `local_file.config`, but the failing check is a `validation`
block on `variable "filename"`. Terraform's `expect_failures` must reference the exact location
of the failing check.

## Mapping Checks to expect_failures Targets

| Check type               | Target format              |
|--------------------------|----------------------------|
| Variable `validation`    | `var.<name>`               |
| Resource `precondition`  | `resource_type.name`       |
| Resource `postcondition` | `resource_type.name`       |
| Output `precondition`    | `output.<name>`            |

## Why Precision Matters
If `expect_failures` targets the wrong check, Terraform either:
- Reports the test as passing (the wrong check is targeted and happens to not fail), or
- Reports an unexpected failure at the correct check.

Both outcomes make tests unreliable. Matching the target to the check's location is essential.
""",
        "common_mistakes": """\
# Common Mistakes

- **Targeting the resource when the check is on a variable** — common for validation failures.
- **Targeting the wrong resource** — if there are multiple resources, pick the one with the check.
- **Using the output name for a resource postcondition** — the target is the resource, not the
  output that reads from it.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 18 — test-setup-teardown
# ─────────────────────────────────────────────────────────────────────────────
def _level_18_test_setup_teardown():
    return {
        "module": MODULE,
        "slug": "level-18-test-setup-teardown",
        "mission": {
            "name": "Missing Resource Referenced in Assertion",
            "description": "A two-run test: `run \"setup\"` applies first, then `run \"check\"` asserts `output.manifest_path`. But `manifest_path` references `local_file.manifest`, which does not exist in `main.tf`. Add the missing resource.",
            "objective": "Add the `local_file.manifest` resource and its output to `main.tf` so the multi-run test passes.",
            "xp": 325,
            "difficulty": "advanced",
            "expected_time": "25m",
            "concepts": ["test setup", "multi-run", "state persistence across runs"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# The test expects a local_file.manifest resource and output.manifest_path,
# but they are not defined here.

resource "local_file" "config" {
  content  = "base config"
  filename = "${path.module}/config.txt"
}

output "config_path" {
  value = local_file.config.filename
}
""",
            "tests/main.tftest.hcl": """\
run "setup" {
  command = "apply"
  # Creates all resources including the expected manifest
}

run "check" {
  command = "apply"

  assert {
    # manifest_path output does not exist — local_file.manifest resource is missing
    condition     = output.manifest_path != ""
    error_message = "Manifest path should be set after setup run."
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "base config"
  filename = "${path.module}/config.txt"
}

resource "local_file" "manifest" {
  content  = "manifest data"
  filename = "${path.module}/manifest.txt"
}

output "config_path" {
  value = local_file.config.filename
}

output "manifest_path" {
  value = local_file.manifest.filename
}
""",
            "tests/main.tftest.hcl": """\
run "setup" {
  command = "apply"
}

run "check" {
  command = "apply"

  assert {
    condition     = output.manifest_path != ""
    error_message = "Manifest path should be set after setup run."
  }
}
""",
        },
        "validate": VALIDATE_TEST,
        "hints": [
            "Run `terraform test`. The error will say `output.manifest_path` does not exist.",
            "The test expects the config to produce a `manifest_path` output. Look at `main.tf` — neither `local_file.manifest` nor the `output \"manifest_path\"` block exists.",
            "Add `resource \"local_file\" \"manifest\" { ... }` and `output \"manifest_path\" { value = local_file.manifest.filename }` to `main.tf`.",
        ],
        "debrief": """\
# Missing Resource Referenced in Assertion

## What Was Broken
The second `run "check"` block asserted `output.manifest_path`, but `main.tf` had no
`local_file.manifest` resource and no `manifest_path` output. The test was written ahead of the
implementation.

## Multi-Run Test Pattern (Setup + Verify)
```hcl
run "setup" {
  command = "apply"
  # Optionally override variables for initial state
}

run "verify" {
  command = "apply"
  # Assert on outputs produced by setup
  assert {
    condition     = output.manifest_path != ""
    error_message = "Manifest path should be set."
  }
}
```

## Key Points About Multi-Run Tests
- Both runs share the same ephemeral test state.
- Resources created in `run "setup"` are available in `run "verify"`.
- After all `run` blocks complete, Terraform destroys the test state automatically.
- You can use `run "teardown" { command = "apply" }` with a variables override to simulate
  destruction of specific resources mid-test.

## Why It Matters
Test-driven development (writing tests before the implementation) is a powerful practice. But
the test must match the final implementation. When a test references a resource or output that
doesn't exist, the fix is to implement the missing piece in the config.
""",
        "common_mistakes": """\
# Common Mistakes

- **Asserting outputs that don't exist** — always verify the output name exists in `main.tf`.
- **Expecting isolated state per run** — runs share state; a resource created in run 1 still
  exists in run 2.
- **Forgetting that test state is ephemeral** — resources are destroyed after the test completes;
  do not rely on test-created files for subsequent `terraform apply` runs.
""",
    }


if __name__ == "__main__":
    build()
