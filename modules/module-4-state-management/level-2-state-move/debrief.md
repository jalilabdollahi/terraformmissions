# State Mover

## What Was Broken
The `local_file` resource was missing the required `filename` argument. Without it, `terraform apply`
fails immediately.

## The Fix
```hcl
resource "local_file" "old_name" {
  content  = "managed by terraform"
  filename = "${path.module}/managed.txt"
}
```

## terraform state mv
`terraform state mv` moves a resource from one address to another **within the same state file**
without destroying and recreating the actual resource. This is essential when you rename a resource
in your configuration — without a `moved {}` block or a `state mv`, Terraform would destroy the old
one and create a new one.

```bash
terraform state mv local_file.old_name local_file.new_name
```

## Why It Matters
Real-world refactoring often involves renaming resources. `state mv` is the escape hatch when
you can't (or don't want to) use a `moved {}` block.