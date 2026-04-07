# Length Function

## What Was Broken
`var.items.nonexistent` tried to access a key called `nonexistent` on the map variable, which
doesn't exist. The fix is to call `length()` on the map itself.

## The Fix
```hcl
count = length(var.items)   # returns 3 for a map with 3 keys
```

## length() Behavior
```hcl
length("hello")          # → 5  (string length in characters)
length(["a", "b", "c"])  # → 3  (list length)
length({a=1, b=2})       # → 2  (map key count)
```

## Why It Matters
`length()` is one of the most-used Terraform functions. Knowing it works on strings, lists,
and maps avoids the need to extract keys separately before counting.