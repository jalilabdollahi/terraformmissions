# Password Written to Plaintext File

## What Was Broken
`local_file` creates files with default permissions (typically `0644`) — readable by all users
on the system. Writing a password to such a file violates the principle of least-privilege access.

## local_sensitive_file vs local_file
| Resource               | Default permissions | Use for |
|------------------------|---------------------|---------|
| `local_file`           | `0644`              | Non-sensitive content |
| `local_sensitive_file` | `0600`              | Secrets, credentials, keys |

`local_sensitive_file` also marks its `content` attribute as sensitive, which prevents the
value from appearing in plan/apply output.

## A Note on State
Even with `local_sensitive_file`, the credential value is stored in `terraform.tfstate` in
plaintext. Protect state files with:
- Remote state with encryption (S3 + SSE, GCS + CMEK, Terraform Cloud).
- Access controls on the state backend.
- Never committing `terraform.tfstate` to version control.

## Why It Matters
A credentials file with `0644` permissions can be read by any user on a shared system. This
is a real-world attack vector on multi-user Linux hosts.