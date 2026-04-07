# Sensitive Output Leak

## What Was Broken
The `output "db_password"` block exposed `random_password.db.result` without `sensitive = true`.
This means the password would appear in plain text in:
- `terraform apply` CLI output
- `terraform output` CLI output
- Any CI/CD log that captures stdout

## The Fix
```hcl
output "db_password" {
  value     = random_password.db.result
  sensitive = true
}
```

## What sensitive = true Does
- Redacts the value in CLI output (shows `<sensitive>`).
- Prevents the value from being shown in `terraform output` without `-json` or `-raw`.
- Marks the output as sensitive so downstream module callers cannot accidentally expose it.

## Note on State
`sensitive = true` does NOT encrypt the value in state. The value is still stored in plaintext
in `terraform.tfstate`. Use remote state with encryption (e.g., S3 + SSE, Terraform Cloud) to
protect secrets at rest.

## Why It Matters
Passwords in CLI output are logged by CI/CD systems, terminal history, and pipeline artifacts.
Marking outputs sensitive is a minimal but important first line of defence.