# Walkthrough — Mycelium Batch Cards

1. **Plan.** Terraform lists every bad reference:
   ```
   Error: Unsupported attribute
     on main.tf line 16, in output "batch":
     This object does not have an attribute named "batch_code".
   ```
   The same appears for `humidity` and `card_path`.
2. **List what the module offers.** `grep -n '^output' modules/cellar/main.tf` prints `batch_id`,
   `humidity_pct` and `card_file`.
3. **Edit the root outputs** to `module.cellar.batch_id`, `module.cellar.humidity_pct`, `module.cellar.card_file`.
4. `terraform apply`, then `check`.
