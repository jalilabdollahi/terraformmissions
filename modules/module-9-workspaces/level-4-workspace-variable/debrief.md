# Map Lookup Gone Wrong

## What Was Broken
`locals` is the **block keyword** used to declare local values. To **reference** a local value,
the correct prefix is `local.` (singular), not `locals.`.

## The Fix
```hcl
current_config = local.env_config[terraform.workspace]
```

## locals Block vs local. Reference
```hcl
# Declaration — uses "locals" (plural) block keyword
locals {
  my_value = "hello"
}

# Reference — uses "local." (singular) prefix
output "example" {
  value = local.my_value
}
```

## Map Lookup with workspace
```hcl
locals {
  env_map = {
    default    = "dev"
    staging    = "staging"
    production = "prod"
  }
  env = local.env_map[terraform.workspace]
}
```
Use `try(local.env_map[terraform.workspace], "dev")` if not all workspaces are guaranteed to be in the map.