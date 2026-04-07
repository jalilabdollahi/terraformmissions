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