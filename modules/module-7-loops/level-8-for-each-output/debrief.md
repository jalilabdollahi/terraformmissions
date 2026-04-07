# Wrong Attribute in for Expression

## What Was Broken
`v.path` does not exist on `local_file` resources. The correct attribute is `v.filename`.

## local_file Key Attributes
```hcl
resource "local_file" "example" {
  content  = "..."
  filename = "/path/to/file.txt"
}
# Attributes: .filename, .content, .id, etc. — no .path
```

## for Expression Syntax
```hcl
{ for k, v in local_file.configs : k => v.filename }
# Returns: { "dev" = "config-dev.txt", "prod" = "config-prod.txt" }
```

## Concepts
- Resource attribute names are defined by the provider schema
- Use `terraform providers schema -json` to inspect available attributes