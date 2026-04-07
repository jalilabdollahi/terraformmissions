# Secrets Leaking into State

## What Was Broken
1. `local_file` writes with world-readable permissions and no sensitivity marking.
2. The `output` block exposes the password in plain text in terminal output.

## The Fix
```hcl
resource "local_sensitive_file" "secret" {
  content  = random_password.db_pass.result
  filename = "${path.module}/secret.txt"
}

output "db_password" {
  value     = random_password.db_pass.result
  sensitive = true
}
```

## Sensitive Value Best Practices
- Use `local_sensitive_file` for files containing secrets (sets mode 0600).
- Mark outputs `sensitive = true` to prevent plain-text display.
- Note: Terraform state still contains the value — use remote state with encryption.
- For true ephemeral secrets, use Vault or cloud-native secret managers.

## Why It Matters
Secrets written to plain-text files or displayed in output can be captured in logs, CI pipelines,
and shared terminals. Defense in depth requires sensitivity marking at every layer.