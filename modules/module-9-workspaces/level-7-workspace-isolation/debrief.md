# Name Collision Across Workspaces

## What Was Broken
When multiple workspaces share the same working directory, resources with identical names
(like a fixed filename `app.conf`) will overwrite each other. Each workspace should produce
uniquely named resources.

## The Fix
```hcl
resource "local_file" "app_config" {
  content  = "env=${terraform.workspace}"
  filename = "${path.module}/app-${terraform.workspace}.conf"
}
```

## Workspace Isolation Pattern
Include `terraform.workspace` in any resource name, filename, or identifier that needs to be
unique per environment:

```hcl
# Resource tags
tags = {
  Environment = terraform.workspace
  Name        = "${var.name}-${terraform.workspace}"
}

# Filenames
filename = "${path.module}/${terraform.workspace}-config.txt"
```

## Why It Matters
Without workspace-unique names, deploying to `staging` can overwrite `default` resources,
causing silent data loss or configuration corruption.