# Object Missing a Required Key

## What Was Broken
The `object` type constraint declares two required keys: `name` (string) and `port` (number).
The default value only provided `name`, leaving `port` missing.

## The Fix
```hcl
default = {
  name = "app"
  port = 8080
}
```

## `object` Type Rules
- Every key declared in `object({...})` is **required** in any value assigned to the variable
- Extra keys NOT declared in the type are **rejected** (unless using `optional()`)
- Each key's value must match its declared type

## Optional Keys (Terraform >= 1.3)
```hcl
type = object({
  name = string
  port = optional(number, 8080)  # optional with default
})
```

With `optional()`, the key can be omitted from the default and caller values.

## Why It Matters
`object` types are strict by default — all declared keys are required. This is intentional:
it forces callers to make all required choices explicit.