# String Functions

## What Was Broken
`replace()` was called with 4 arguments. The function signature is:
```
replace(string, search, replacement)
```
The `"g"` flag (global replace) is a concept from some regex flavors but is not a Terraform
`replace()` parameter — Terraform always replaces all matches globally.

## The Fix
```hcl
locals {
  cleaned = replace(var.name, "/[^a-z]/", "-")
}
```

## replace() Signatures
```hcl
replace("hello world", "world", "terraform")   # → "hello terraform"
replace("Hello123", "/[^a-z]/", "-")           # → "--ello---"  (regex replace)
```

When `search` is wrapped in `/…/`, it's treated as a regular expression.

## Why It Matters
String manipulation functions are used constantly for generating resource names, sanitizing
inputs, and building dynamic values. Knowing the exact signatures prevents subtle errors.