# The Wrong Breadcrumb

## What Was Broken
`local_file` does not expose a `.path` attribute. The file path is available through `.filename`,
which mirrors the name of the input argument used to create it.

## The Fix
```hcl
content = "secondary config references: ${local_file.first.filename}"
```

## `local_file` Exported Attributes

| Attribute              | Description |
|-----------------------|-------------|
| `filename`             | The path of the created file |
| `id`                   | SHA1 hash (used as resource ID) |
| `content_md5`          | MD5 hash of the content |
| `content_sha1`         | SHA1 hash of the content |
| `content_sha256`       | SHA256 hash of the content |
| `content_sha512`       | SHA512 hash of the content |
| `content_base64sha256` | SHA256 of the content, base64-encoded |
| `content_base64sha512` | SHA512 of the content, base64-encoded |

## Implicit Dependencies
By referencing `local_file.first.filename`, Terraform automatically creates an implicit ordering
dependency. `local_file.second` will always be created after `local_file.first`.

## Why It Matters
Knowing which attributes a resource exports requires checking the provider documentation. The
`terraform providers schema -json` command can also dump the full resource schema.