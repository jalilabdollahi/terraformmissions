# Wrong JSON Key

## What Was Broken
`jsondecode` successfully parsed the JSON, but the key `"wrong_key"` does not exist in the
decoded map. Terraform catches this during planning.

## The Fix
```hcl
output "app_name" {
  value = local.parsed["app_name"]
}
```

## Key Concepts
- `jsondecode(string)` converts a JSON string into a Terraform value (map, list, etc.).
- Accessing a missing key on a Terraform map causes a plan-time error.
- Use `try(local.parsed["key"], "default")` if the key may be absent.

## Common Pattern
```hcl
locals {
  config = jsondecode(data.local_file.config.content)
}
output "env" {
  value = local.config["env"]
}
```