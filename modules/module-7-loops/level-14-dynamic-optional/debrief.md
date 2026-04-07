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