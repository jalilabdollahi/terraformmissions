# Missing File, Missing Guard

## What Was Broken
The data source referenced a file that does not exist. Without a guard, Terraform raises an
error during the plan phase and halts execution.

## The Fix
```hcl
output "file_content" {
  value = try(data.local_file.maybe.content, "default")
}
```

## try() Function
`try(expr1, expr2, ...)` evaluates each expression left to right and returns the first one
that does not produce an error. It is the idiomatic Terraform way to handle optional values.

```hcl
# Single fallback
try(some_resource.name.attribute, "fallback")

# Multiple fallbacks
try(map["key"], local.default_map["key"], "hardcoded-default")
```

## Caution
`try()` silently swallows errors. Use it carefully — only wrap the specific expression
that might fail, not an entire block. Overuse of `try()` can hide real configuration errors.

## Alternative: `can()`
`can(expr)` returns `true` if the expression succeeds, `false` otherwise. Useful in
`condition` checks:
```hcl
locals {
  file_exists = can(data.local_file.maybe.content)
}
```