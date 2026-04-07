# Ghost Resource

## What Was Broken
A `removed` block and a `resource` block for the same address cannot coexist. The `removed` block
is specifically designed for the transition period after you delete the `resource` block — it tells
Terraform what to do with the existing state entry.

## The Fix
Delete the `resource "local_file" "old" { ... }` block. The `removed` block alone is sufficient.

## removed Block (Terraform 1.7+)
```hcl
removed {
  from = local_file.old
  lifecycle {
    destroy = false  # keep the real file; just forget it in state
  }
}
```

## Why It Matters
Without a `removed` block, deleting a resource from config causes Terraform to destroy the real
infrastructure. The `removed` block gives you a safe off-ramp: remove from state without destroying.