# Declarative Import

## What Was Broken
The `import` block's `id` pointed to `/wrong/path/config.txt` instead of `${path.module}/config.txt`.
The ID must match the actual file path that the `local_file` resource manages.

## The Fix
```hcl
import {
  to = local_file.config
  id = "${path.module}/config.txt"
}
```

## Import Blocks (Terraform 1.5+)
The `import {}` block is the modern, declarative way to import resources:
```hcl
import {
  to = <resource_address>
  id = "<resource_id>"
}
```

Unlike `terraform import` (CLI), import blocks are:
- Stored in version control
- Part of the plan phase (visible in `terraform plan`)
- Automatically removed after the first `terraform apply`

## Why It Matters
Declarative imports make the import process auditable and repeatable, fitting naturally into
GitOps workflows where every change is reviewed before being applied.