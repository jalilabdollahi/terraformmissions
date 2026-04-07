# Force Replace

## What Was Broken
The `null_resource` trigger still referenced `"v1"` even though the application moved to v2.
Since triggers hadn't changed, Terraform saw no reason to replace the resource.

## The Fix
```hcl
resource "null_resource" "task" {
  triggers = {
    version = "v2"
  }
  ...
}
```

## Triggers and Force Replace
`null_resource` triggers work like change detectors — when trigger values change, the resource
is replaced (destroyed and recreated), re-running all provisioners.

For one-off forced replacements without config changes:
```bash
terraform apply -replace=null_resource.task
```

## Why It Matters
Triggers are how you tell Terraform "this resource must run again when X changes." Common use
cases: re-running scripts when a config file changes, re-executing deployments when an image version bumps.