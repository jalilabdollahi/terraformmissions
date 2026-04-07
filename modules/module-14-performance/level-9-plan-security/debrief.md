# Plan File Security

## What Was Broken
The `database_password` output was missing `sensitive = true`. The raw password appeared in:
- `terraform plan` terminal output (visible in CI/CD logs)
- `terraform apply` output
- Saved plan files (stored in plain text if the file is not encrypted)
- `terraform output` command output

## The Fix
Add `sensitive = true` to the `database_password` output block.

## What sensitive = true Does
- Redacts the value in plan/apply/show output (shows `(sensitive value)`)
- Prevents accidental exposure in CI/CD logs and terminal history
- Marks downstream references as sensitive automatically
- Does NOT encrypt the value in state — the state file still stores it in plain text

## Real Secret Management
`sensitive = true` is a display guard, NOT a security boundary:
- State file contains the plain text value
- Operator with state access can always read it
- For production secrets, use an external secret store:
  - HashiCorp Vault (with vault provider)
  - AWS Secrets Manager / SSM Parameter Store
  - Azure Key Vault
  - GCP Secret Manager

## Key Takeaway
Mark ALL secret outputs as `sensitive = true` as a defense-in-depth measure. But also treat
your state file as a secret — restrict access, encrypt at rest, and use a secure backend.