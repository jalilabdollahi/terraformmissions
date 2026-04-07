# Accessing a Key That Doesn't Exist

## What Was Broken
`var.config.nonexistent_key` references an attribute that is not declared in the `object` type.
The valid keys are `name` (string) and `version` (number).

## The Fix
```hcl
output "app_name" {
  value = var.config.name
}
```

## Object Attribute Access Syntax

```hcl
# Given:
variable "config" {
  type = object({ name = string, version = number })
  default = { name = "my-app", version = 2 }
}

# Access individual attributes:
var.config.name      # "my-app"
var.config.version   # 2
```

## Defensive Access with `try()`
If a key might not exist (e.g., with `optional()` keys), use `try()`:

```hcl
output "app_name" {
  value = try(var.config.name, "default-app")
}
```

## Why It Matters
Object attribute access errors are caught at plan time. When working with complex object variables,
always cross-reference the `type` declaration to confirm which keys are available.