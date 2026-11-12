# Walkthrough — Saltmarsh Tide Card

1. **Run `terraform init`** (the same message shows up for plan, apply and validate once providers are installed):
   ```
   Error: Unsupported Terraform Core version
     on terraform.tf line 3, in terraform:
      3:   required_version = ">= 0.12, < 1.0"
   This configuration does not support Terraform version 1.17.0. To proceed, either choose
   another supported Terraform version or update this version constraint.
   ```
2. **Check your version** with `terraform version`. It is 1.x, above the `< 1.0` ceiling.
3. **Edit the constraint** in `terraform.tf` to something modern, e.g. `">= 1.10"`.
4. **Re-run** `terraform validate` and `terraform apply`.
