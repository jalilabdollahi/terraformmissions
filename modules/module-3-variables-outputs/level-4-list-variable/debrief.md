# One Number Ruins the List

## What Was Broken
`list(string)` enforces that **every element** is a string. The value `3` (without quotes) is a
number literal, violating the constraint.

## The Fix
```hcl
default = ["a", "b", "3"]
```

## `list` vs `tuple`

| Type           | Constraint |
|---------------|------------|
| `list(string)` | All elements must be the same type (string) |
| `tuple([string, string, number])` | Each element has its own declared type |

If you need a list where elements can be different types, use `tuple`.

## Why It Matters
Typed collections (`list(string)`, `map(number)`, etc.) enforce consistency. A single wrong-typed
element fails the entire variable. Check every element when setting a default for a typed list.