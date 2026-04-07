# Resource as for_each Value

## What Was Broken
`for_each = local_file.configs` passes the resource collection directly.
Terraform's `for_each` requires an explicit `map` or `set`, not a resource object.

## Converting Resource to Map
```hcl
for_each = { for k, v in local_file.configs : k => v.filename }
# Produces: { "alpha" = "config-alpha.txt", "beta" = "config-beta.txt" }
```

Then `each.key` is the label and `each.value` is the filename string.

## Why Not Directly?
Passing a resource object would theoretically work if it were a map type,
but Terraform requires the for_each value to be known at plan time in a structured way.

## Concepts
- `for_each` must receive a `map` or `set` value
- Use `for` expressions to transform resource outputs into maps