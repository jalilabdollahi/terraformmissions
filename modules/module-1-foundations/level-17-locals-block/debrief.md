# Double Vision

## What Was Broken
`locals` blocks are key-value maps. Duplicate keys are a parse error.

## locals vs variables
| | `variable` | `local` |
|--|-----------|---------|
| Set by | caller / env / tfvars | defined in config |
| Read-only | ✅ | ✅ |
| Can reference other locals | ❌ | ✅ |
| Can be overridden externally | ✅ | ❌ |

## Using locals for DRY code
```hcl
locals {
  prefix = "${var.env}-${var.region}"
  bucket_name = "${local.prefix}-data"
}
```

Locals are great for computed values or to avoid repeating the same expression.