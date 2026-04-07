# each.name vs each.key

## What Was Broken
`each.name` is not a valid attribute. The correct attributes are `each.key` and `each.value`.

## each Object Attributes
| Attribute | Value |
|----------|-------|
| `each.key` | The map key (or set element) for the current iteration |
| `each.value` | The map value for the current iteration |

## Example
```hcl
for_each = { web = "nginx", db = "postgres" }

# In each iteration:
each.key   = "web"     (then "db")
each.value = "nginx"   (then "postgres")
```

## Concepts
- `each.key` and `each.value` are the only two attributes of the `each` object
- For `toset()`, `each.key == each.value` (sets don't have separate key/value)