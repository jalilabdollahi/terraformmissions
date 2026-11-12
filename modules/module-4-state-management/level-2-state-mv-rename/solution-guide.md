# Walkthrough — The Lighthouse Rename

1. **See the problem.** `terraform plan` shows `random_pet.keeper` *will be destroyed* and
   `random_pet.night_keeper` *will be created*. A rename in the code looks to Terraform like "delete
   one thing, create another".
2. **Check what state holds.**
   ```bash
   terraform state list
   # local_file.roster
   # random_pet.keeper
   ```
3. **Move the object to its new address.**
   ```bash
   terraform state mv random_pet.keeper random_pet.night_keeper
   ```
   Terraform rewrites the address in state only. Nothing real is changed.
4. **Confirm.** `terraform plan` should now say *No changes*. Then type `check`.
