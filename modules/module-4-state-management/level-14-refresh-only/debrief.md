# Refresh Only

## What Was Broken
The output referenced `local_file.data.size`, which is not an attribute exported by the
`local_file` resource. Valid attributes include `filename`, `content`, `id`, and `content_base64`.

## The Fix
```hcl
output "file_info" {
  value = local_file.data.filename
}
```

## terraform apply -refresh-only
`terraform apply -refresh-only` updates the state file to reflect reality without making any
infrastructure changes. It's the safe way to resync state after out-of-band changes:

```bash
terraform apply -refresh-only
```

Compare with:
- `terraform refresh` (deprecated) — did the same thing
- `terraform plan -refresh-only` — shows what would change in state without applying

## Why It Matters
Refresh-only mode is essential for reconciling drift without accidentally applying config changes.
Use it when you know the infrastructure changed externally and you want to accept those changes.