# Walkthrough — Legacy Orchard Tags

1. **Read the error.**
   ```bash
   terraform plan
   # Error: Missing required provider
   # This state requires provider registry.terraform.io/-/random, but that provider isn't available.
   terraform init
   # Error: Invalid legacy provider address
   # This configuration or its associated state refers to the unqualified provider "random".
   ```
2. **Confirm in the state.**
   ```bash
   grep '"provider"' terraform.tfstate
   # "provider": "provider[\"registry.terraform.io/-/random\"]"
   ```
3. **Rewrite the address.**
   ```bash
   terraform state replace-provider registry.terraform.io/-/random registry.terraform.io/hashicorp/random
   # Terraform will perform the following actions: ~ Updating provider ... for 2 resources
   # Do you want to make these changes?  yes
   ```
4. `terraform init`, then `terraform plan`: no changes, and the crate tag is the original one. Type `check`.
