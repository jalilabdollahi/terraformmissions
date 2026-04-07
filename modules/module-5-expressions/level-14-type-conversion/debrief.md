# Type Conversion

## What Was Broken
`tolist()` is used to convert tuples and sets to lists. It cannot convert maps because maps
have key-value pairs, not ordered elements.

## The Fix
```hcl
locals {
  as_list = values(var.my_map)
  # → ["apple", "banana"] (order may vary)
}
```

## Map-to-List Conversions
```hcl
keys(map)              # list of keys:   ["a", "b"]
values(map)            # list of values: ["apple", "banana"]
[for k, v in map : v]  # same as values, but with transformation
```

## tolist() Valid Uses
```hcl
tolist(toset(["a","b","c"]))   # set → list
tolist(["a","b","c"])          # tuple → list (explicit typing)
```

## Why It Matters
Terraform's type system distinguishes lists, sets, tuples, and maps. Using the wrong conversion
function is a type error caught at validate time.