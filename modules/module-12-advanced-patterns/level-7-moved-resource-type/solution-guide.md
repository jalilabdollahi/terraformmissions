# Walkthrough: Retiring The Null Ledger

1. **Validate.**
   ```
   Error: Unsupported argument
     on main.tf line 8, in resource "terraform_data" "launch_ledger":
     An argument named "triggers" is not expected here.
   ```
2. **Map the argument.** `null_resource.triggers` -> `terraform_data.triggers_replace`. (`terraform_data`
   also has `input`/`output`, which are different.)
3. **Plan.** Now it shows `null_resource.launch_ledger will be destroyed` and
   `terraform_data.launch_ledger will be created`, a new ID.
4. **Add the move.**
   ```hcl
   moved {
     from = null_resource.launch_ledger
     to   = terraform_data.launch_ledger
   }
   ```
5. **Plan again.** It says `null_resource.launch_ledger has moved to terraform_data.launch_ledger`,
   0 to add or destroy. Apply and type `check`.
