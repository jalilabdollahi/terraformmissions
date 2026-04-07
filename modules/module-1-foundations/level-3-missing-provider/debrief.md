# The Missing Provider

## What Was Broken
The version constraint `>= 99.0` demands a version of `hashicorp/local` that doesn't exist.
The Terraform registry has no version 99.x, so `terraform init` fails immediately.

## Version Constraint Syntax
| Constraint | Meaning |
|-----------|---------|
| `= 2.5.0`  | Exactly this version |
| `~> 2.5`   | >= 2.5.0, < 3.0.0 (pessimistic) |
| `>= 2.4`   | Any version 2.4 or higher |
| `>= 2.4, < 3.0` | Range |

## Best Practice
Use `~> X.Y` (pessimistic constraint operator) — it allows patch upgrades within a minor version,
which is the right balance between stability and security updates.

## Commands You Used
```bash
terraform init   # downloads providers specified in required_providers
```