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