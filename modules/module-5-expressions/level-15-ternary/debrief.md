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