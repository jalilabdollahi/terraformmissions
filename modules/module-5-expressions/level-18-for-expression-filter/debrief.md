# For Expression Filter

## What Was Broken
`x > 10` compared a string element to a number. Even though the strings look like numbers
(`"5"`, `"15"`), Terraform's type system requires explicit conversion.

## The Fix
```hcl
locals {
  big_items = [for x in var.items : x if tonumber(x) > 10]
  # → ["15", "20"]
}
```

## Type Conversion in Filters
When your list contains numeric strings and you need arithmetic comparisons:
```hcl
[for x in var.items : x if tonumber(x) > 10]
```

Or change the variable type to `list(number)` if the values are always numbers:
```hcl
variable "items" {
  type    = list(number)
  default = [5, 15, 3, 20]
}
# Then: [for x in var.items : x if x > 10]
```

## Why It Matters
Terraform's type system is strict about comparisons. Understanding when to use `tonumber()`,
`tostring()`, or `tobool()` prevents subtle type errors in for expressions.