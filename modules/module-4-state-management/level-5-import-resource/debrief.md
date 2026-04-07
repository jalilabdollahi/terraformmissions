# Resource Importer

## What Was Broken
The `filename` attribute pointed to `/tmp/tm_wrong_path.txt` but the import target was
`/tmp/tm_existing.txt`. For `local_file`, the resource ID **is** the filename path, so they must match.

## The Fix
```hcl
resource "local_file" "existing" {
  content  = "pre-existing file content"
  filename = "/tmp/tm_existing.txt"
}
```

## terraform import
`terraform import` brings an existing real-world resource under Terraform management:
```bash
terraform import <resource_address> <resource_id>
terraform import local_file.existing /tmp/tm_existing.txt
```

The resource ID format varies by resource type — check the provider documentation for the correct ID format.

## Why It Matters
When you take over infrastructure that was created manually (or by another tool), `import` lets
you adopt it into Terraform state without destroying and recreating it.