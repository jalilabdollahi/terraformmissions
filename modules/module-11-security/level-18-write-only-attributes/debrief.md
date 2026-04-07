# Password Exposed via nonsensitive() to Plain File

## What Was Broken
Two security mistakes compounded:
1. `nonsensitive(random_password.db.result)` stripped the sensitive marking from the password.
2. The stripped value was written to `local_file` — a world-readable file.

The result: a password that `random_password` correctly marked as sensitive was fully exposed
on disk in a permissive file.

## Legitimate nonsensitive() Use (Kept in Solution)
```hcl
output "password_check" {
  value = "Password length: ${nonsensitive(length(random_password.db.result))}"
}
```
Here, `nonsensitive()` is applied to the *length* of the password, not the password itself.
The length is not sensitive information — it's fine to display it.

## Write-Only Pattern for Credentials
The ideal pattern for writing credentials to disk:
```hcl
resource "local_sensitive_file" "db_password" {
  content         = random_password.db.result  # no nonsensitive() wrapper
  filename        = "${path.module}/db_password.txt"
  file_permission = "0600"
}
```

## End-to-End Sensitive Data Handling Checklist
- [ ] Variable: `sensitive = true`
- [ ] File resource: `local_sensitive_file`, not `local_file`
- [ ] No `nonsensitive()` on raw secret values
- [ ] Output: `sensitive = true` (or do not output the raw value)
- [ ] State: encrypted remote backend

## Why It Matters
`nonsensitive()` is the "override security" function. Every call to it should be reviewed as
a security decision. Wrapping a password in it to solve a type error is always wrong — use
`local_sensitive_file` or a secrets manager instead.