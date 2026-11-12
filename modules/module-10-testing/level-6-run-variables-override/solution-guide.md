# Walkthrough - Overstocked Aquarium

1. `terraform test` ends with `Failure! 1 passed, 1 failed, 1 skipped.` The failing run is `crowded_tank`:
   ```
   Error: Invalid value for input variable
     on tests/tank.tftest.hcl line 20, in run "crowded_tank":
   The given value is not suitable for var.tank_liters ...: a number is required.
   ```
   `"40 litres"` is not convertible to a number. Use `tank_liters = 40`.
2. The skipped run is not broken *yet*: after a run fails, Terraform skips the remaining runs of that file
   because they may depend on its state. Re-run and `guppy_swarm` now fails:
   `var.stock ... map of number required`. The override is `["guppy", "guppy"]`; the declaration is
   `map(number)`, so write `stock = { guppy = 30 }`.
3. Final run: `Success! 3 passed, 0 failed.`
4. Check the declarations in `tank.tf` whenever an override is rejected - the variable type is the contract.
