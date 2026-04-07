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