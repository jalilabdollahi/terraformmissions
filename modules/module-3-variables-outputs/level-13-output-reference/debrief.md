# Local File Has No Content Output

## What Was Broken
`content` is an input argument for `local_file` — you use it to specify what to write. However,
the resource does not re-export `content` as a computed attribute. Terraform rejects the reference.

## The Fix
```hcl
output "config_path" {
  value = local_file.config.filename
}
```

## Input Arguments vs Exported Attributes
A resource's **input arguments** (what you configure) are different from its **exported attributes**
(what you can read back):

| Input argument | Purpose |
|---------------|---------|
| `content`      | Specifies file content to write |
| `filename`     | Specifies the file path |

| Exported attribute | What it contains |
|-------------------|-----------------|
| `filename`         | The file path (same as input) |
| `id`               | SHA1 hash of content |
| `content_md5`      | MD5 hash |
| `content_sha256`   | SHA256 hash |

## Why It Matters
Not all input arguments are readable back as attributes. Check the "Attributes Reference" section
of the provider docs (distinct from "Argument Reference") to see what is exported.