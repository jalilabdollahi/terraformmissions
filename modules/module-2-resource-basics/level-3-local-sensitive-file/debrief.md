# Permission Denied by Design

## What Was Broken
`local_sensitive_file` requires the `file_permission` argument. Unlike `local_file`, this resource
forces you to think about file security — it will not let you forget to set permissions.

## The Fix
```hcl
resource "local_sensitive_file" "secret" {
  content         = "super-secret-api-key=abc123"
  filename        = "${path.module}/secret.txt"
  file_permission = "0600"
}
```

## Understanding Unix File Permissions

| Permission | Meaning |
|-----------|---------|
| `0600`    | Owner read + write only (recommended for secrets) |
| `0640`    | Owner read+write, group read |
| `0644`    | Owner read+write, group+others read |

For secret files, always use `0600` to prevent other users from reading sensitive data.

## `local_sensitive_file` vs `local_file`
- `local_sensitive_file`: marks content as sensitive (hidden in plan output), requires explicit permissions
- `local_file`: general purpose, content visible in plan output

## Why It Matters
Secret files with wrong permissions are a common security vulnerability. Terraform enforces best
practices by making `file_permission` required on `local_sensitive_file`.