# State Eraser

## What Was Broken
`local_file.file_a` referenced `local_file.file_b.filename` in its content, while `local_file.file_b`
referenced `local_file.file_a.filename`. This created a circular dependency that Terraform cannot resolve.

## The Fix
Make `file_a` independent and establish a one-way dependency from `file_b` to `file_a`:
```hcl
resource "local_file" "file_a" {
  content  = "I am file A"
  filename = "${path.module}/file_a.txt"
}

resource "local_file" "file_b" {
  content  = "depends on: ${local_file.file_a.filename}"
  filename = "${path.module}/file_b.txt"
}
```

## terraform state rm
`terraform state rm` removes a resource from state without deleting the real resource.
Use cases:
- Resource is now managed outside Terraform
- You want Terraform to "forget" a resource without running a destroy

```bash
terraform state rm local_file.file_b
```

## Why It Matters
Circular dependencies are a common mistake when resources reference each other. Understanding the
dependency graph (visible via `terraform graph`) helps you design correct resource relationships.