# The tfvars Assignment Operator

## What Was Broken
`environment "production"` is missing the `=` assignment operator. The `.tfvars` format requires
`key = value` syntax on every line.

## The Fix
```hcl
environment = "production"
```

## `.tfvars` File Format
`.tfvars` files use a simplified subset of HCL:

```hcl
# Simple assignments
region      = "us-east-1"
instance_count = 3
enable_logging = true

# Complex types
tags = {
  owner = "team-a"
  env   = "prod"
}

subnets = ["subnet-abc", "subnet-def"]
```

## How `.tfvars` Files Are Loaded
| Filename pattern       | When loaded |
|-----------------------|-------------|
| `terraform.tfvars`     | Automatically by Terraform |
| `terraform.tfvars.json`| Automatically by Terraform |
| `*.auto.tfvars`        | Automatically by Terraform |
| `custom.tfvars`        | Must pass with `-var-file=custom.tfvars` |

## Why It Matters
`.tfvars` syntax errors are distinct from HCL block syntax errors. The format is simpler but still
requires the `=` operator. Missing it is a common copy-paste or muscle-memory mistake.