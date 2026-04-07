# Token Validation Trap

## What Was Broken
The regex `^[0-9a-f]{32,128}$` only accepts lowercase hexadecimal strings.
A real-world auth token `MyService-Token-ABC123-xyz789-ABCDEF` contains uppercase letters
and hyphens, which are rejected.

## The Fix
```hcl
validation {
  condition     = can(regex("^[A-Za-z0-9-]{32,128}$", var.auth_token))
  error_message = "auth_token must be a valid token (alphanumeric and hyphens, 32-128 chars)."
}
```

## Regex in Terraform Validations
- `can(regex(...))` returns `true` if the regex matches, `false` otherwise.
- Always test your regex against representative values including edge cases.
- Use online regex testers to verify patterns before committing.

## Auth Pattern Best Practices
- Store tokens in secure backends (Vault, AWS Secrets Manager) — not in variables with defaults.
- Use `sensitive = true` on token variables.
- Mark the resource as `local_sensitive_file` if writing tokens to disk.

## Why It Matters
Overly restrictive validation blocks legitimate configurations. Overly permissive validation
allows invalid values through. Strike the right balance by understanding the actual token format.