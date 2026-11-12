# Walkthrough — Stale Bean Lock

1. **Read the error.**
   ```bash
   terraform init
   # Error: Failed to query available provider packages
   # ... locked provider registry.terraform.io/hashicorp/random 3.5.1 does not match
   # configured version constraint ~> 3.6; must use terraform init -upgrade
   # to allow selection of new versions
   ```
2. **Look at both files.** `grep -A3 random .terraform.lock.hcl` shows `version = "3.5.1"`, while terraform.tf
   asks for `~> 3.6`.
3. **Upgrade the lock.**
   ```bash
   terraform init -upgrade
   ```
   Terraform picks the newest allowed version and rewrites `.terraform.lock.hcl`.
4. `terraform apply`, then type `check`.
