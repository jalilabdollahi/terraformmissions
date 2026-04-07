# Quoted Numbers Are Not Numbers

## What Was Broken
`default = "42"` is a string in HCL, not a number. The `type = number` constraint requires
an unquoted numeric literal.

## The Fix
```hcl
variable "replica_count" {
  type    = number
  default = 42
}
```

## HCL Literal Types at a Glance

| Value     | Type   |
|----------|--------|
| `42`      | number |
| `"42"`    | string |
| `true`    | bool   |
| `"true"`  | string |
| `3.14`    | number |
| `"3.14"`  | string |

## Why It Matters
While Terraform sometimes attempts automatic type coercion (e.g., `"42"` → `42`), it is not
guaranteed and varies between versions. Always use the correct literal type to avoid subtle bugs.