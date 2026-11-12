# Walkthrough — Hartley Planetarium Posters

1. **Run `terraform validate`.**
   ```
   Error: Duplicate resource "local_file" configuration
     on posters.tf line 2, in resource "local_file" "poster":
   A local_file resource named "poster" was already declared at main.tf:7,1-31. Resource names must be unique per type in each module.
   ```
2. **Understand the address.** `local_file.poster` is the object's identity in state. Two blocks cannot share one.
3. **Rename the newer block** in `posters.tf` to `local_file.eclipse_poster`. Keep the original name in `main.tf`, so the
   comet poster stays the same object in state.
4. **Apply.** Both files are written; `terraform state list` shows two `local_file` entries.
