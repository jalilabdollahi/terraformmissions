# False is Not a String

## What Was Broken
`default = "false"` is a string literal. The `type = bool` constraint requires an unquoted boolean
literal (`true` or `false`).

## The Fix
```hcl
variable "enable_logging" {
  type    = bool
  default = false
}
```

## Boolean Literals in HCL

| Value     | Type   | Meaning |
|----------|--------|---------|
| `true`    | bool   | Correct boolean true |
| `false`   | bool   | Correct boolean false |
| `"true"`  | string | Wrong — a string, not a bool |
| `"false"` | string | Wrong — a string, not a bool |

## Why It Matters
Using `"false"` (string) instead of `false` (bool) is one of the most common type mistakes in
Terraform. The string `"false"` is truthy in many languages — but Terraform's type system rejects
it outright when `type = bool` is declared.