# Provider Auth Incident — Incident Post-Mortem

## The Incident
A provider block referenced `var.api_key` for credentials, but the variable declared in
`variables.tf` was named `api_secret`. This caused a validation error — Terraform reports
an undeclared variable reference.

In a real cloud provider scenario (AWS, GCP, Azure), this manifests as:
```
Error: Reference to undeclared input variable
  on provider.tf line 5: var.api_key
  There is no variable named "api_key".
```

## The Fix
Correct the variable reference to match the declared variable name: `var.api_secret`.
Or, if the provider doesn't need the argument, remove the erroneous reference entirely.

## Provider Auth Debugging Checklist
1. **Check variable names** — declared name in `variables.tf` must match `var.<name>` reference
2. **Check environment variables** — `TF_VAR_api_secret` must match the variable name
3. **Check for typos** — `api_key` vs `api_secret` vs `api_token` are common confusion points
4. **Validate before plan** — `terraform validate` catches undefined variable references
5. **Check sensitive variables** — sensitive vars must be provided via env var or var file

## Real Provider Auth Patterns
```hcl
# AWS
provider "aws" {
  access_key = var.aws_access_key  # var must be declared
  secret_key = var.aws_secret_key  # var must be declared
  region     = var.aws_region
}

# Environment variable alternative (recommended):
# TF_VAR_aws_access_key=... terraform apply
```

## Key Takeaway
Provider auth failures often look like API errors but are actually config errors. Always
`terraform validate` before debugging network/auth issues with the real provider API.