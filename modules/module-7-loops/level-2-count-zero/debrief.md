# Referencing a Zero-Count Resource

## What Was Broken
`local_file.config[0].filename` errors when `count = 0` because instance `[0]` doesn't exist.

## The try() Function
`try(expression, fallback)` returns `expression` if it succeeds, or `fallback` if it errors:

```hcl
output "config_path" {
  value = try(local_file.config[0].filename, "")
}
```

## Alternative: Use one() or check count
```hcl
output "config_path" {
  value = length(local_file.config) > 0 ? local_file.config[0].filename : ""
}
```

Or use `one()` which returns null for empty collections:
```hcl
output "config_path" {
  value = one(local_file.config[*].filename)
}
```

## Concepts
- `count = 0` is a valid way to conditionally create/destroy a resource
- Always guard outputs that reference conditional resources