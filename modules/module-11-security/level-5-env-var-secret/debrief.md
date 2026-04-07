# Wrong Variable Name for TF_VAR_ Injection

## What Was Broken
The variable was named `DB_PASSWORD` (uppercase). Terraform's `TF_VAR_` mechanism uses the
environment variable name converted to lowercase to match the variable name. So
`TF_VAR_DB_PASSWORD` would work, but `TF_VAR_db_password` would not — and the latter is the
conventional form.

## TF_VAR_ Naming Rules
- The env var `TF_VAR_foo` maps to the variable `foo`.
- Variable names should be lowercase with underscores by convention.
- HCL identifiers are case-sensitive: `DB_PASSWORD` and `db_password` are different variables.

## Best Practice for Secrets via Environment Variables
```bash
export TF_VAR_db_password="my-secure-password"
terraform apply
```
This avoids storing secrets in files entirely. The secret lives only in the shell environment.

## Why It Matters
A mis-named variable silently falls back to the default value. If the default is a weak
placeholder, production systems might run with insecure credentials without any error.