# Interpolation Implosion

## What Was Broken
Two errors in one:
1. `$()` is bash command substitution — HCL uses `${}`
2. Inside HCL interpolation, variables are referenced as `var.name`, not just `name`

## HCL Interpolation
```hcl
"Hello, ${var.name}!"      # variable
"Path: ${path.module}"     # built-in reference
"ID: ${resource.type.name.attr}"  # resource attribute
```

## When NOT to Use Interpolation
If the entire value is a single reference, you don't need quotes at all:
```hcl
value = var.environment          # No interpolation needed
value = "${var.environment}"     # Works but unnecessary wrapper
```
The direct form `value = var.environment` is preferred by `terraform fmt`.