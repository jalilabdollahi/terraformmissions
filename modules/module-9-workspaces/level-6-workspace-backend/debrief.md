# No Interpolation in Backend

## What Was Broken
Backend configuration blocks do not support interpolation or expressions. They are processed
before the Terraform language runtime initialises, so `${terraform.workspace}` has no meaning there.

## The Fix
```hcl
backend "local" {
  path = "terraform.tfstate"
}
```

## How Workspaces Isolate State Automatically
When using workspaces, Terraform automatically separates state:
- **default workspace**: `terraform.tfstate`
- **other workspaces**: `terraform.tfstate.d/<workspace-name>/terraform.tfstate`

You do **not** need to include the workspace name in the path — it is handled automatically.

## Key Rule
Backend blocks must contain only literal values (strings, numbers, booleans). No variables,
no locals, no `terraform.workspace`.

## Dynamic Backend Alternative
Use `-backend-config` flags or environment variables for dynamic backend configuration:
```bash
terraform init -backend-config="path=envs/staging/terraform.tfstate"
```