# Flatten

## What Was Broken
`flatten([["a","b"], "c"])` mixed a list `["a","b"]` with a bare string `"c"`. `flatten()`
requires all top-level elements to be lists (they can be nested arbitrarily deep).

## The Fix
```hcl
locals {
  items = flatten([["a", "b"], ["c"]])
  # → ["a", "b", "c"]
}
```

## flatten() Behavior
```hcl
flatten([[1, 2], [3, 4]])        # → [1, 2, 3, 4]
flatten([[1, [2, 3]], [4]])      # → [1, 2, 3, 4]  (recursive)
flatten([["a"], [], ["b","c"]])  # → ["a", "b", "c"]
```

## Common Pattern with for_each
```hcl
locals {
  all_rules = flatten([
    for group in var.security_groups : group.rules
  ])
}
```

## Why It Matters
`flatten()` combined with `for` expressions is a fundamental pattern for transforming
nested data structures into flat lists suitable for `for_each`.