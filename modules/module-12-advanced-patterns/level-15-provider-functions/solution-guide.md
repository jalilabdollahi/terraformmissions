# Walkthrough: Axe Bar Tfvars Writer

1. **Validate.**
   ```
   Error: Unknown provider function
   There is no function named "provider::terraform::encode_tfvars". Ensure that provider name "terraform" is
   declared in this module's required_providers block, and that this provider offers a function named "encode_tfvars".
   ```
2. **Declare the provider.** The functions belong to the built-in provider `terraform.io/builtin/terraform`.
   In `terraform.tf`:
   ```hcl
   required_providers {
     local     = { source = "hashicorp/local", version = "~> 2.5" }
     terraform = { source = "terraform.io/builtin/terraform" }
   }
   ```
   It needs no version and nothing to download, but the harness runs `terraform init` for you on `check`.
3. **Apply.** `stack/night.tfvars` now holds sorted, correctly formatted HCL, nested object included, and
   `seat_growth = 8`. Type `check`.
