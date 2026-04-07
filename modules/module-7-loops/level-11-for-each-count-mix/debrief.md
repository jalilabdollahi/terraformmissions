# count vs for_each Addressing

## What Was Broken
`module.mymod["key"]` uses string key notation, which is for `for_each` modules.
`count` modules use integer indices.

## Addressing Summary
| Meta-argument | Instance Address |
|--------------|-----------------|
| `count = 2` | `module.mymod[0]`, `module.mymod[1]` |
| `for_each = toset(["a","b"])` | `module.mymod["a"]`, `module.mymod["b"]` |

## Migration: count to for_each
When switching from `count` to `for_each`, resource addresses change — use `moved` blocks
to prevent destroy/create cycles.

## Concepts
- `count` modules: addressed by integer index `[N]`
- `for_each` modules: addressed by string key `["key"]`