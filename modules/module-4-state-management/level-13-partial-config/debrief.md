# Partial Backend Config

## What Was Broken
The backend block referenced `var.state_path`. Terraform's backend configuration is processed
**before** variables are evaluated, so variable references in backend blocks are not supported.

## The Fix
```hcl
backend "local" {
  path = "terraform.tfstate"
}
```

## Partial Backend Configuration
For dynamic backend values, use the `-backend-config` flag:
```bash
terraform init -backend-config="path=terraform.tfstate"
```

Or a separate file:
```hcl
# backend.tfbackend
path = "terraform.tfstate"
```
```bash
terraform init -backend-config=backend.tfbackend
```

## Why It Matters
Backend configuration must be static because it's needed to retrieve state — which happens
before any variable resolution. This is a fundamental Terraform bootstrap constraint.