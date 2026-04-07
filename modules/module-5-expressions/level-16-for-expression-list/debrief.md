# For Expression List

## What Was Broken
`item.value` tried to access an attribute on a string. Strings are scalar values — they have
no attributes. The fix is to use the string directly or apply a string function.

## The Fix
```hcl
locals {
  values = [for item in var.items : upper(item)]
  # → ["APPLE", "BANANA", "CHERRY"]
}
```

## For Expression Syntax
```hcl
[for <item> in <collection> : <expression>]
[for <item> in <collection> : <expression> if <condition>]
[for <key>, <value> in <map> : "<key>=<value>"]
```

## Why It Matters
For expressions are the primary tool for transforming collections in Terraform. Knowing the
element type (string, object, map) determines what operations are valid inside the expression.