# Walkthrough — Ashgrove Deed Box

1. `terraform plan -destroy` currently lists both resources as *will be destroyed*. Nothing stands in the way of `terraform destroy`.
2. Protect each resource with a lifecycle block:
   ```hcl
   resource "random_password" "box_master" {
     ...
     lifecycle {
       prevent_destroy = true
     }
   }
   ```
   Do the same on `local_sensitive_file.deed_register`. The argument must be a literal `true`: lifecycle settings cannot use variables.
3. Verify: `terraform plan -destroy` now fails with `Error: Instance cannot be destroyed ... resource ... has lifecycle.prevent_destroy set`.
4. `terraform plan` (no `-destroy`) must still be clean. Type `check`.
