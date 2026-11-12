# Walkthrough - Archive Door Schema

1. `terraform validate` lists three `Unsupported argument` errors. Each one names the resource type but not what
   to use instead.
2. Dump the schema once:
   ```bash
   terraform providers schema -json > schema.json
   ```
3. List the attributes of each resource type involved:
   ```bash
   jq -r '.provider_schemas["registry.terraform.io/hashicorp/random"].resource_schemas.random_password.block.attributes | keys[]' schema.json
   jq -r '.provider_schemas["registry.terraform.io/hashicorp/local"].resource_schemas.local_sensitive_file.block.attributes | keys[]' schema.json
   jq -r '.provider_schemas["registry.terraform.io/hashicorp/time"].resource_schemas.time_offset.block.attributes | keys[]' schema.json
   ```
   Each attribute also has `"optional"`, `"required"` or `"computed"` flags and a `"type"`.
4. Rename the arguments: `special_chars` -> `special`, `permissions` -> `file_permission`, `days` -> `offset_days`.
5. `terraform apply`, then `check`. (Delete `schema.json` afterwards; it is large and not part of the config.)
