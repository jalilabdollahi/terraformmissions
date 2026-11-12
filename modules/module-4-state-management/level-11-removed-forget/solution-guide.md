# Walkthrough — Night Market Handoff

1. **Understand the trap.** If you delete `resource "local_file" "permit_book"` and run `terraform plan`,
   it says `will be destroyed`: the clerk's file would disappear.
2. **Replace the block with a removed block.**
   ```hcl
   removed {
     from = local_file.permit_book

     lifecycle {
       destroy = false
     }
   }
   ```
3. **Plan.** Terraform reports `local_file.permit_book will no longer be managed by Terraform, but will not be destroyed`.
4. **Apply** to drop the object from state: `terraform apply`.
5. `ls permits/` still shows the book, and `terraform plan` is clean. Type `check`.
