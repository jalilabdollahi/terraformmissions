# Concat vs Merge

## What Was Broken
`merge()` was called on lists. It only accepts maps/objects. Lists are combined with `concat()`.

## The Fix
```hcl
locals {
  combined = concat(["a", "b"], ["c"])
  # → ["a", "b", "c"]
}
```

## concat() vs merge()
| Function   | Input types | Purpose                          |
|-----------|-------------|----------------------------------|
| `concat()` | lists/tuples | Combine multiple lists into one  |
| `merge()`  | maps/objects | Merge maps (later keys win)       |

```hcl
concat(["a"], ["b", "c"])      # → ["a", "b", "c"]
merge({x=1}, {y=2, x=99})     # → {x=99, y=2}  (second x wins)
```

## Why It Matters
Choosing the wrong combination function is a type error caught at validate time. Understanding
the type model — lists vs maps — is fundamental to writing correct Terraform expressions.