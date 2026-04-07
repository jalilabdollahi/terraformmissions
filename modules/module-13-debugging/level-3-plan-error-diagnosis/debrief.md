# Plan Failure Forensics

## What Was Broken
`null_resource.watcher` referenced `local_file.nonexistent.id`, but no `local_file.nonexistent`
resource was declared. Terraform caught this at plan time.

## The Fix
```hcl
resource "null_resource" "watcher" {
  triggers = {
    config_id = local_file.config.id
  }
}
```

## Reading Plan Errors
Terraform's plan errors always include:
1. The file and line number
2. The undeclared reference
3. A suggestion for what might be intended

## Why It Matters
Plan errors due to dangling references are always safe — they mean nothing has been changed.
Fix the reference by matching it to a declared resource.