# Type Mismatch at the Module Boundary

## What Was Broken
`port = "8080"` passes a *string*. The child module's variable declares `type = number`,
so Terraform rejects the value with a type error.

## HCL Literal Types
```hcl
port = "8080"   # string
port = 8080     # number
port = true     # bool
```

## Terraform's Type System at Module Boundaries
When a root module passes a value to a child module, Terraform enforces the declared type constraint.
While Terraform can sometimes auto-convert (e.g., `"1"` to `1`), explicit mismatches like passing
a clearly quoted string for a `number` type are rejected at validation time.

## Concepts
- `type = number` — accepts integers and floats, not quoted strings
- Quotes in HCL always produce a string literal