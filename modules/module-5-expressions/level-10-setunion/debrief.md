# Set Union

## What Was Broken
`setunion()` requires set arguments. Lists and sets are distinct types in Terraform. The
`toset()` function converts a list to a set.

## The Fix
```hcl
locals {
  combined = setunion(toset(["a", "b"]), toset(["c"]))
  # → toset(["a", "b", "c"])
}
```

## Set Functions
```hcl
setunion(toset([1,2]), toset([2,3]))         # → {1, 2, 3}
setintersection(toset([1,2]), toset([2,3]))  # → {2}
setsubtract(toset([1,2,3]), toset([2]))      # → {1, 3}
```

## Sets vs Lists
- Sets have no defined order
- Sets cannot contain duplicate elements
- Use `tolist(set)` to convert back to a list (order is undefined)

## Why It Matters
Set operations are essential for computing permissions, security group rules, and other
"union of requirements" patterns that appear in infrastructure-as-code.