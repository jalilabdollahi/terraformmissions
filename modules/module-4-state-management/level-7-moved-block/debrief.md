# The Moved Block

## What Was Broken
The resource was renamed in the config without a `moved {}` block. Terraform saw `local_file.old_name`
disappear and `local_file.new_name` appear — and planned to destroy the old one and create a new one.

## The Fix
```hcl
moved {
  from = local_file.old_name
  to   = local_file.new_name
}

resource "local_file" "new_name" {
  content  = "managed file content"
  filename = "${path.module}/managed.txt"
}
```

## moved {} Block
Introduced in Terraform 1.1, `moved {}` blocks record resource renames in your configuration:
- No CLI commands needed
- Version-controlled and reviewable
- Automatically processed during `terraform apply`
- Can be removed after all consumers have applied the change

## Why It Matters
Without `moved {}`, renaming a resource causes unnecessary destroy+create cycles. In production,
this can mean downtime. The `moved {}` block makes refactoring safe.