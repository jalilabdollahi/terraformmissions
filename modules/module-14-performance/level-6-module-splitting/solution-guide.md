# Walkthrough — Candle Works Split

1. **Inventory.** `terraform state list` shows four objects under `module.workshop`.
2. **Create the modules.**
   - `modules/pour`: `random_id.batch`, `local_file.pour_sheet`, output `batch_code`.
   - `modules/wick`: `local_file.wick_spec`, output `wick_cm`.
   - `modules/label`: `local_file.label` with inputs `batch_code`, `wick_cm`, `scent`.
   Keep the `${path.root}/out/...` file names so the file paths do not change.
3. **Rewire the root.** Three module calls; `label` gets `module.pour.batch_code` and
   `module.wick.wick_cm`. Remove `module "workshop"` and delete `modules/workshop`.
4. **Add moved blocks** for the four resources, from `module.workshop.*` to the new homes.
5. **Verify.** `terraform plan` reports four resources moved and nothing destroyed;
   after `terraform apply` the state has `module.pour.random_id.batch` with the same hex.
