# Walkthrough — Berth Sheet Import

1. **First error.** `terraform plan` fails with
   `Configuration for import target does not exist` for `random_integer.berth_no`. The `to` address
   must match a resource block: `random_integer.berth_number`.
2. **Second problem.** After fixing the name, the plan shows
   `random_integer.berth_number must be replaced` with `~ min = 1 -> 100 # forces replacement`.
   The ID is `<result>,<min>,<max>`. We wrote `1` as the minimum, the code says `100`.
3. **Correct block.** `harbour/berth-sheet.txt` lists the berth number and the pool 100 to 999:
   ```hcl
   import {
     to = random_integer.berth_number
     id = "417,100,999"      # your berth number will differ
   }
   ```
4. `terraform plan` now says `1 to import, 0 to add, 0 to change`. Run `terraform apply` to record
   the import in state.
5. A final `terraform plan` is clean. Type `check`.
