# Unconditional prevent_destroy Blocks All Environments

## What Was Broken
`prevent_destroy = true` was hardcoded. This protects production as intended but also prevents
destruction in `dev`, `staging`, and CI test workspaces, making cleanup impossible without
editing the config.

## Conditional prevent_destroy
```hcl
lifecycle {
  prevent_destroy = terraform.workspace == "production"
}
```
This evaluates to `true` only in the `production` workspace, and `false` in all others.

## What prevent_destroy Does
When set to `true`, any `terraform destroy` or plan that would destroy this resource will fail
with an error. It is a safety net against accidental deletion of critical infrastructure.

## Workspace-Aware Security Patterns
```hcl
locals {
  is_production = terraform.workspace == "production"
}

resource "local_file" "config" {
  ...
  lifecycle {
    prevent_destroy = local.is_production
  }
}
```

## Why It Matters
Hardcoded `prevent_destroy = true` in shared modules means all environments inherit the
protection, blocking legitimate dev/test teardown workflows.