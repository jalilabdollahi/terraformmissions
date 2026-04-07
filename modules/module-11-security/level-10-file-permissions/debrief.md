# Overly Permissive File Permissions

## What Was Broken
`file_permission = "777"` creates a file that any user on the system can read, modify, or
execute. For a secret file, this is equivalent to leaving your password printed on a public board.

## Unix Permission String Reference
| Octal String | Permissions |
|--------------|-------------|
| `"0600"`     | Owner: read+write. Group: none. Others: none. |
| `"0644"`     | Owner: read+write. Group: read. Others: read. |
| `"0400"`     | Owner: read. Group: none. Others: none. |
| `"0755"`     | Owner: read+write+exec. Group: read+exec. Others: read+exec. |
| `"0777"`     | Everyone: read+write+exec. Never use for secrets. |

## Octal String Format
Terraform expects a 4-digit octal string (e.g., `"0600"`). The leading zero is important —
it signals octal notation. Without it, `"600"` is parsed as decimal `600`, not octal `600`.

## Why It Matters
File permission errors are a common OWASP finding in security audits. Any process running
as another user on the same host can read `777` files, including container breakout scenarios.