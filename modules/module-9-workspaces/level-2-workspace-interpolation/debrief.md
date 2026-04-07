# Unquoted String in Condition

## What Was Broken
`default` without quotes is treated as an identifier (a reference to a variable or object named
`default`), not the string `"default"`. HCL string literals require double quotes.

## The Fix
```hcl
locals {
  env = terraform.workspace == "default" ? "dev" : terraform.workspace
}
```

## String Literals in HCL
```hcl
# Correct — double-quoted string
condition = terraform.workspace == "default"

# Wrong — unquoted identifier
condition = terraform.workspace == default
```

## Conditional Expression Syntax
```
condition ? true_value : false_value
```
Both `true_value` and `false_value` must be valid expressions of the same type.