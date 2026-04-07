# Sets Don't Allow Duplicates

## What Was Broken
`set(string)` enforces that all elements are unique. The default `["a", "b", "a"]` contains `"a"`
twice, violating this constraint.

## The Fix
```hcl
default = ["a", "b"]
```

## `list` vs `set`

| Feature        | `list(string)` | `set(string)` |
|---------------|----------------|---------------|
| Order          | Preserved      | Not guaranteed |
| Duplicates     | Allowed        | Not allowed    |
| Index access   | `var.x[0]`     | Not supported  |
| Use with `for_each` | Requires `toset()` | Direct use |

## When to Use `set`
Use `set` when:
- You need uniqueness enforced
- Order doesn't matter
- You plan to use the variable with `for_each`

## Why It Matters
`set` is commonly used with `for_each` to create one resource per unique value. Duplicate elements
would create ambiguous resource addressing.