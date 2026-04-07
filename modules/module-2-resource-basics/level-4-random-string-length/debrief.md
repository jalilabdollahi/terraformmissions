# Zero is Nothing

## What Was Broken
`random_string` enforces that `length` must be at least 1. Setting `length = 0` violates this
constraint and causes `terraform validate` to fail immediately.

## The Fix
```hcl
resource "random_string" "token" {
  length  = 16
  special = false
  upper   = false
}
```

## `random_string` Common Attributes

| Attribute          | Default | Description |
|-------------------|---------|-------------|
| `length`           | required | Number of characters (minimum: 1) |
| `upper`            | true    | Include uppercase letters |
| `lower`            | true    | Include lowercase letters |
| `numeric`          | true    | Include digits |
| `special`          | true    | Include special characters |
| `override_special` | `""`    | Limit special chars to this set |

## Why It Matters
Validation constraints catch impossible configurations before any API calls are made. Understanding
provider-enforced minimum/maximum constraints saves debugging time.