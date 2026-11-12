# Walkthrough — Boiler Shed Extraction

1. **Plan.** It lists `random_id.ticket` and `local_file.manifest` to be destroyed, and `module.shed.random_id.ticket`
   and `module.shed.local_file.manifest` to be created. A new ticket id would invalidate the printed paperwork.
2. **Check state.** `terraform state list` shows the old root addresses.
3. **Declare the moves** in the root configuration:
   ```hcl
   moved {
     from = random_id.ticket
     to   = module.shed.random_id.ticket
   }

   moved {
     from = local_file.manifest
     to   = module.shed.local_file.manifest
   }
   ```
4. `terraform plan` now reports "has moved to" and no destroy. Apply, confirm the ticket is unchanged, then `check`.
