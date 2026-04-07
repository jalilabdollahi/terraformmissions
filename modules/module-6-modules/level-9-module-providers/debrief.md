# Wrong Provider Alias in Module

## What Was Broken
The `providers` argument in the module block mapped `local` to `local.wrong_alias`,
but the root only declares `provider "local" { alias = "primary" }`.

## Provider Aliases Syntax
```hcl
provider "local" {
  alias = "primary"   # declares alias
}

module "mymod" {
  source = "./modules/writer"
  providers = {
    local = local.primary   # pass alias to child
  }
}
```

## Why Pass Providers to Modules
By default a module inherits the default (un-aliased) provider configuration.
Use `providers` to explicitly pass a specific alias when you have multiple
configurations for the same provider type.

## Concepts
- Provider aliases are referenced as `<type>.<alias>` (e.g., `local.primary`)
- The `providers` map in a module call remaps provider types for the child