# The Wrong Type Blocks the Flag

## What Was Broken
The variable `environment` was declared as `type = number`, but the intended values (`"dev"`,
`"staging"`, `"prod"`) are strings. Passing `-var="environment=staging"` fails because `staging`
cannot be converted to a number.

## The Fix
```hcl
variable "environment" {
  type    = string
  default = "dev"
}
```

## Variable Precedence (Lowest to Highest)
1. Default values in variable declarations
2. `terraform.tfvars` file
3. `*.auto.tfvars` files (alphabetical order)
4. `-var-file` flag values
5. `-var` flag values
6. Environment variables (`TF_VAR_<name>`)

Higher-precedence sources override lower ones. The `-var` flag is near the top, making it useful
for one-off overrides in CI/CD pipelines.

## Why It Matters
Variable type declarations affect how all value sources (flags, tfvars, env vars) are interpreted.
Getting the type right is foundational for a module that accepts values from multiple sources.