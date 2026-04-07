# Lost in Encoding

## What Was Broken
The output referenced `content_base64`, which returns the file contents encoded as a Base64 string.
The intent was to expose the raw text.

## The Fix
```hcl
output "readme_text" {
  value = data.local_file.readme.content
}
```

## Attributes of `data "local_file"`
| Attribute        | Description |
|-----------------|-------------|
| `content`        | UTF-8 decoded file content (plain text) |
| `content_base64` | Base64-encoded raw bytes (for binary files) |
| `filename`       | Absolute path of the file (computed) |
| `id`             | SHA1 checksum of the file content |

## Why It Matters
When reading binary files (images, archives), use `content_base64`. For text configs, use `content`.
Mixing them up can cause subtle bugs in downstream interpolations.