# Broken Child Module Syntax

## What Was Broken
The child module used `file_content` as an argument for the `local_file` resource.
The actual argument name is `content`. Terraform's validation catches unknown arguments.

## local_file Resource Arguments
```hcl
resource "local_file" "example" {
  content  = "file contents"   # correct
  filename = "/path/to/file.txt"
}
```

## Finding Correct Argument Names
Run `terraform providers schema -json` or check the provider documentation at
`registry.terraform.io` to see all valid arguments for a resource type.

## Concepts
- Resource argument names are defined by the provider, not by you.
- `terraform validate` catches unknown argument names.