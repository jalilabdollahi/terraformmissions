# For Expression Map

## What Was Broken
`{for k, v in var.tags : k, v}` used a comma where `=>` is required. In HCL, the `=>`
(fat arrow) separates the key expression from the value expression in a map-producing for
expression.

## The Fix
```hcl
locals {
  tag_map = {for k, v in var.tags : k => v}
}
```

## For Expression Syntax: List vs Map
```hcl
# List-producing
[for v in collection : expression]

# Map-producing (key => value)
{for k, v in collection : key_expr => value_expr}
{for k, v in collection : key_expr => value_expr if condition}
```

## Transformation Examples
```hcl
# Uppercase all tag values
{for k, v in var.tags : k => upper(v)}

# Flip keys and values
{for k, v in var.tags : v => k}

# Filter and transform
{for k, v in var.tags : k => v if k != "internal"}
```

## Why It Matters
The `=>` separator is the syntactic marker that tells HCL "produce a map, not a list."
Forgetting it or using `,` is one of the most common for-expression mistakes.