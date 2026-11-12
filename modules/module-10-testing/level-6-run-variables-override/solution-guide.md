# Walkthrough - Overstocked Henhouse

1. `terraform test` ends with `Failure! 1 passed, 1 failed, 1 skipped.` The failing run is `crowded_coop`:
   ```
   Error: Invalid value for input variable
     on tests/coop.tftest.hcl line 20, in run "crowded_coop":
   The given value is not suitable for var.coop_sqft ...: a number is required.
   ```
   `"40 sqft"` is not convertible to a number. Use `coop_sqft = 40`.
2. The skipped run is not broken *yet*: after a run fails, Terraform skips the remaining runs of that file
   because they may depend on its state. Re-run and `bantam_flock` now fails:
   `var.stock ... map of number required`. The override is `["bantam", "bantam"]`; the declaration is
   `map(number)`, so write `stock = { bantam = 30 }`.
3. Final run: `Success! 3 passed, 0 failed.`
4. Check the declarations in `coop.tf` whenever an override is rejected - the variable type is the contract.
