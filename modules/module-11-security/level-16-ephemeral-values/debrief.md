# Sensitive Variable Passed Without Protection

## What Was Broken
Two separate issues combined to expose a sensitive API token:
1. `local_file` (world-readable) was used instead of `local_sensitive_file` (owner-only).
2. `output "token_preview"` exposed the sensitive variable without `sensitive = true`.

## Defence in Depth for Sensitive Values
Sensitive values need protection at every layer:

| Layer               | Protection |
|---------------------|------------|
| Variable declaration | `sensitive = true` |
| File storage         | `local_sensitive_file` with `"0600"` permissions |
| Output declaration   | `sensitive = true` |
| State storage        | Encrypted remote backend |

## Systematic Review Process
When reviewing configs that handle secrets, check:
1. Is every output that touches the secret marked `sensitive`?
2. Is every file that stores the secret using `local_sensitive_file`?
3. Is `nonsensitive()` used anywhere? If so, is it justified?
4. Is the secret stored in state? If yes, is state encrypted?

## Why It Matters
Sensitive values require end-to-end protection. A single unprotected output or world-readable
file can expose credentials that took significant effort to otherwise protect.