# Walkthrough — Lost Surplus Inventory

1. **See the damage.**
   ```bash
   terraform state list
   # local_file.inventory_index
   terraform plan
   # Plan: 3 to add, 1 to change, 0 to destroy.
   ```
2. **Find the safety copy** (`apply` saved the previous state when it wrote the new one).
   ```bash
   ls -l terraform.tfstate terraform.tfstate.backup
   terraform state list -state=terraform.tfstate.backup
   # shows all four objects
   ```
3. **Restore it.** Before anything else touches the state:
   ```bash
   cp terraform.tfstate.backup terraform.tfstate
   ```
   Alternatively `terraform state push -force terraform.tfstate.backup` (the backup's serial is older than the current one, so `-force` is required).
4. **Verify.** `terraform plan` prints "No changes". The manager name is the old one. Type `check`.

Do this *before* running any other state-changing command: each one overwrites the backup file.
