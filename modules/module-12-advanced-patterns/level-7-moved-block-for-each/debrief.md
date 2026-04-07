# Key Quoting in moved Block

## What Was Broken
`local_file.items[primary]` uses an unquoted identifier `primary` as an instance key.
For `for_each` resources with string keys, the key must be quoted: `local_file.items["primary"]`.

## The Fix
```hcl
moved {
  from = local_file.items[0]
  to   = local_file.items["primary"]
}
```

## Instance Address Syntax
| Instance type | Address format |
|---|---|
| `count` | `resource_type.label[0]` |
| `for_each` (string key) | `resource_type.label["key"]` |
| `for_each` (number key) | `resource_type.label[42]` |

## Why It Matters
count-to-for_each migration is one of the most common Terraform refactoring patterns.
The `moved` block makes this safe by preserving state, but the address syntax must be exact.