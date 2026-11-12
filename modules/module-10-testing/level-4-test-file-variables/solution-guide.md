# Walkthrough - Rook Club Pairings

1. `terraform test`:
   ```
   Error: Unsupported argument
     on tests/pairings.tftest.hcl line 1:
   An argument named "variables" is not expected here. Did you mean to define a block of type "variables"?
   ```
2. In a `.tftest.hcl` file the file-level inputs are a **block**: `variables { ... }`. The `variables = {...}`
   spelling is the object-valued attribute you may know from `.tfvars` or module calls, and it is not legal here.
3. Remove the `=`:
   ```hcl
   variables {
     club    = "Rook and Pawn"
     players = ["Ines", "Tomas", "Wen", "Abebe"]
   }
   ```
4. Re-run. Without the block (or with it inside a single run) you would see `No value for required variable`
   instead, because `club` and `players` have no defaults in `pairings.tf`.
5. `Success! 2 passed, 0 failed.`
