# State Remove

## What Was Broken
`local_files` is not a valid resource type. The Hashicorp `local` provider provides `local_file`
(singular). The trailing 's' caused a provider validation error.

## The Fix
```hcl
resource "local_file" "config" {
  content  = "state rm demo"
  filename = "${path.module}/config.txt"
}
```

## terraform state rm
`terraform state rm` removes a resource from state without destroying the actual resource:
```bash
terraform state rm local_file.config
```

After `state rm`:
- The file still exists on disk
- Terraform no longer manages it
- The next `terraform plan` will show it as a new resource to create (if the config still declares it)

## Use Cases for state rm
- Migrating resources to a different state file
- Handing a resource over to another team or tool
- Emergency cleanup when a resource is stuck in a bad state

## Why It Matters
`state rm` is a powerful escape hatch. Use it carefully — it can leave real resources orphaned
and unmanaged.