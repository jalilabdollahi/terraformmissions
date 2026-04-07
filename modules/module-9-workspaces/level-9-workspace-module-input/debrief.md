# Module Missing Workspace Key

## What Was Broken
The `env_map` was missing the `"default"` key. When running in the default workspace,
`local.env_map[terraform.workspace]` resolves to `local.env_map["default"]`, which
does not exist.

## The Fix
```hcl
locals {
  env_map = {
    default    = "development"
    staging    = "staging"
    production = "production"
  }
}
```

## Passing Workspace-Derived Values to Modules
```hcl
module "app" {
  source = "./modules/app"
  env    = local.env_map[terraform.workspace]
}
```

This is a clean pattern — the root module handles workspace-to-environment translation,
and the child module only knows about `var.env`.

## Alternative with try()
```hcl
env = try(local.env_map[terraform.workspace], "development")
```