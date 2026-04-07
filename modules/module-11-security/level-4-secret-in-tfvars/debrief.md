# Secret in tfvars Exposed via Output

## What Was Broken
The `db_password` variable held a secret from `terraform.tfvars` but was not marked `sensitive`.
The output then printed the value in plain text.

## Dual Sensitivity: Variable + Output
For full protection, mark sensitivity in both places:
```hcl
variable "db_password" {
  type      = string
  sensitive = true   # prevents value from appearing in plan/apply diffs
}

output "db_password" {
  value     = var.db_password
  sensitive = true   # redacts in CLI output
}
```

## tfvars Security Best Practices
- **Never commit `terraform.tfvars` containing secrets to version control**.
- Use `.gitignore` to exclude `*.tfvars` and `*.tfvars.json`.
- Use environment variables (`TF_VAR_db_password`) or secret managers as alternatives.
- Use `*.auto.tfvars` only for non-sensitive defaults.

## Why It Matters
`terraform.tfvars` is often the first place junior practitioners store secrets. Without `sensitive`
markings, those secrets flow through to outputs, logs, and CI artifacts.