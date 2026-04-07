# Base64 or Bust

## What Was Broken
`content_base64` accepts a **base64-encoded** string representing binary data. Passing raw plain text
like `"Hello, Terraform!"` is not valid base64, so the provider rejects it at apply time.

## The Fix
Use the `content` attribute for human-readable text:

```hcl
resource "local_file" "readme" {
  content  = "Hello, Terraform!"
  filename = "${path.module}/readme.txt"
}
```

## `local_file` Content Attributes

| Attribute        | Use when |
|-----------------|----------|
| `content`        | Writing plain text (UTF-8) |
| `content_base64` | Writing binary data encoded as base64 |
| `source`         | Copying an existing file from disk |

These three attributes are **mutually exclusive** — you must use exactly one.

## Why It Matters
Providers often expose multiple ways to supply the same conceptual value (text vs binary vs file path).
Choosing the wrong one produces confusing errors that only appear at apply time.