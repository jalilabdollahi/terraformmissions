# Missing Workspace Key in Map

## What Was Broken
The `workspace_config` map had entries for `staging` and `production`, but not `default`.
When running in the default workspace, `local.workspace_config["default"]` throws an error.

## The Fix
```hcl
locals {
  workspace_config = {
    default    = { env = "development", replicas = 1 }
    staging    = { env = "staging",     replicas = 1 }
    production = { env = "production",  replicas = 3 }
  }
}
```

## Safe Lookup Pattern
If not all workspaces need to be in the map, use `try()` to provide a fallback:
```hcl
locals {
  config = try(
    local.workspace_config[terraform.workspace],
    local.workspace_config["default"]
  )
}
```

## Best Practice
Always include a `default` entry in workspace-keyed maps. It acts as the fallback for any
workspace not explicitly listed and prevents accidental plan failures.