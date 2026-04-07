# Split Personality

## What Was Broken
`main.tf` referenced `var.environment` and `var.debug`, but no `variable` blocks were declared.
Terraform loads all `.tf` files in the directory as a single configuration, but each variable
must be explicitly declared.

## File Organisation Convention
Terraform has no enforced file structure, but this convention is widely adopted:

| File | Contents |
|------|----------|
| `main.tf` | Primary resources |
| `variables.tf` | Input variable declarations |
| `outputs.tf` | Output value declarations |
| `locals.tf` | Local value declarations |
| `versions.tf` / `terraform.tf` | Provider + Terraform block |

## All `.tf` Files Are Equal
Terraform merges all `.tf` files in the same directory. You can declare a variable in any `.tf`
file — the convention is `variables.tf` purely for readability.