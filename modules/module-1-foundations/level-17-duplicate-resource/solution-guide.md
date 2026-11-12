# Walkthrough — Inkwell Row Flash Sheets

1. **Run `terraform validate`.**
   ```
   Error: Duplicate resource "local_file" configuration
     on designs.tf line 2, in resource "local_file" "flash_sheet":
   A local_file resource named "flash_sheet" was already declared at main.tf:7,1-31. Resource names must be unique per type in each module.
   ```
2. **Understand the address.** `local_file.flash_sheet` is the object's identity in state. Two blocks cannot share one.
3. **Rename the newer block** in `designs.tf` to `local_file.anchor_sheet`. Keep the original name in `main.tf`, so the
   swallow sheet stays the same object in state.
4. **Apply.** Both files are written; `terraform state list` designs two `local_file` entries.
