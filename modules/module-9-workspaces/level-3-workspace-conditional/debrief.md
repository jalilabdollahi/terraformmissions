# Production Misspelled

## What Was Broken
The workspace name `"prodution"` is a typo — it is missing the letter `c`. Because string
comparisons in Terraform are exact, the condition `terraform.workspace == "prodution"` will
never be `true` when the actual workspace is named `"production"`.

## The Fix
```hcl
count = terraform.workspace == "production" ? 2 : 1
```

## Why This Is Dangerous
This bug does not cause an error — the plan succeeds, but with the wrong resource count.
Logic bugs from string typos are silent and can lead to under- or over-provisioning.

## Defensive Pattern
Use a variable with validation to enforce workspace names:
```hcl
variable "workspace" {
  default = terraform.workspace
  validation {
    condition     = contains(["default", "staging", "production"], var.workspace)
    error_message = "Workspace must be one of: default, staging, production."
  }
}
```