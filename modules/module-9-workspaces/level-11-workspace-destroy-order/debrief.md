# Wrong Dependency Path

## What Was Broken
Resource B's content contained a hardcoded reference to `default-data.txt`. This breaks
immediately in any workspace other than `default` because resource A writes to
`${terraform.workspace}-data.txt`, not `default-data.txt`.

## The Fix
```hcl
resource "local_file" "resource_b" {
  content    = "resource B referencing: ${path.module}/${terraform.workspace}-data.txt"
  filename   = "${path.module}/${terraform.workspace}-output.txt"
  depends_on = [local_file.resource_a]
}
```

## Key Principle
Any path, name, or identifier that is workspace-specific must use `terraform.workspace`.
Hardcoding workspace names defeats the purpose of workspaces.

## The depends_on Pattern
When resource B logically depends on resource A but does not reference its attributes
directly, use `depends_on` to enforce ordering:
```hcl
depends_on = [local_file.resource_a]
```