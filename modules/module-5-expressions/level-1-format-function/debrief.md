# Format Function

## What Was Broken
`format("%s-%d", "app")` provided only one value for two placeholders. Each placeholder in the
format string must have a corresponding argument.

## The Fix
```hcl
locals {
  app_label = format("%s-%d", "app", 1)
}
```

## format() Specifiers
| Specifier | Type    | Example            |
|-----------|---------|-------------------|
| `%s`      | string  | `format("%s", "hello")` → `"hello"` |
| `%d`      | integer | `format("%d", 42)` → `"42"` |
| `%f`      | float   | `format("%.2f", 3.14)` → `"3.14"` |
| `%v`      | any     | generic value representation |
| `%%`      | literal | produces a `%` character |

## Why It Matters
`format()` is the Terraform equivalent of printf-style formatting. Mismatched argument counts
cause runtime errors that only surface when the expression is evaluated.