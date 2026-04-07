# Contains vs Index

## What Was Broken
`index(list, value)` returns the zero-based position of `value` in `list`, but **errors** if
the value is not present. Since `"d"` is not in `["a","b","c"]`, this always fails.

## The Fix
```hcl
locals {
  is_valid = contains(local.allowed, "d")   # → false, no error
}
```

## index() vs contains()
| Function     | Found     | Not Found    |
|-------------|-----------|--------------|
| `index()`   | returns position | **errors** |
| `contains()` | returns `true` | returns `false` |

Use `index()` only when you're certain the value exists. Use `contains()` for validation checks.

## Why It Matters
Membership checks are common in validation logic, conditional resources, and input sanitization.
Using `index()` for existence checks is a silent bug waiting to cause a runtime failure.