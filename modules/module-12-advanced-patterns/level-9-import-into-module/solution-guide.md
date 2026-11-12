# Walkthrough: Key Number Rk9mPg

1. **Plan.**
   ```
   Error: Configuration for import target does not exist
   The configuration for the given import target random_id.key does not exist.
   ```
2. **Find the real address.** `terraform state list` shows `module.hut.random_pet.mascot`.
   In `modules/hut/main.tf` the key is `resource "random_id" "key"`, so its full address is
   `module.hut.random_id.key`.
3. **Correct the target; leave the block in the root.**
   ```hcl
   import {
     to = module.hut.random_id.key
     id = "Rk9mPg"
   }
   ```
4. **Plan.** `module.hut.random_id.key will be imported`, `module.hut.local_file.keyring will be created`.
   Apply and type `check`.
