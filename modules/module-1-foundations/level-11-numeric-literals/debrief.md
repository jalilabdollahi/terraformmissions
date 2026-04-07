# Type Confusion

## What Was Broken
`length = "16"` passes a string where a number is expected. Terraform's type system is strict.

## HCL Primitive Types
| Type | Example |
|------|---------|
| `string` | `"hello"` |
| `number` | `42` or `3.14` |
| `bool` | `true` or `false` |

## Type Coercion
Terraform *will* auto-coerce in some cases (`"16"` → `16` for some providers), but this is
unreliable and provider-specific. Always use the correct type.

```hcl
length  = 16      # ✅ number
special = false   # ✅ bool
name    = "app"   # ✅ string
```