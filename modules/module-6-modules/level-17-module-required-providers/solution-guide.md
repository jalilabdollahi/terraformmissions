# Walkthrough — Sauna Supper Menu

1. **Init.**
   ```
   Error: Failed to query available provider packages
   Could not retrieve the list of available versions for provider hashicorp/local: no available releases match the
   given constraints ~> 1.4, ~> 2.5
   ```
2. **Find both constraints.** `terraform.tf` says `~> 2.5`; `modules/kitchen/versions.tf` says `~> 1.4`. Constraints from all
   modules are combined.
3. **Relax the module**, e.g. `version = ">= 2.4"` (anything that works with the root's requirement). The module's code
   only uses `local_file`, which is the same in both generations.
4. `terraform init`, apply, `check`.
