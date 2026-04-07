# Mixed Types in a String Map

## What Was Broken
`map(string)` enforces that **every value** in the map is a string. The value `2` (unquoted number)
for key `b` violates this constraint.

## The Fix
```hcl
default = {
  a = "x"
  b = "2"
}
```

## `map` vs `object`

| Type                          | Constraint |
|------------------------------|------------|
| `map(string)`                 | All values must be the same type (string) |
| `object({ a = string, b = number })` | Each key has its own declared type |

If you need map values of different types, use `object({...})`.

## Why It Matters
`map(string)` appears frequently in Terraform for tags, environment variables, and configuration
maps. Every value must be a string — even numeric-looking ones like version numbers or counts.