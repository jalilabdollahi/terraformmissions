# Missing terraform. Prefix

## What Was Broken
`workspace` without a prefix is not a valid Terraform expression. The workspace name is
exposed as `terraform.workspace` — an attribute of the built-in `terraform` object.

## The Fix
```hcl
count = terraform.workspace == "default" ? 1 : 0
```

## The terraform Object
The `terraform` object exposes:
| Attribute              | Description |
|-----------------------|-------------|
| `terraform.workspace` | Current workspace name (string) |
| `terraform.env`       | Deprecated alias for `terraform.workspace` |

## Why `workspace` Alone Fails
Terraform would interpret `workspace` as a reference to a variable named `workspace`.
If no such variable is declared, validation fails.