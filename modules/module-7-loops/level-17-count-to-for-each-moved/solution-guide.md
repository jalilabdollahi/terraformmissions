# Walkthrough - Painted On The Hull

1. `terraform plan` shows three `random_pet.mascot[...]` to destroy (numeric indexes) and three to create
   (`["odette"]`, ...). `terraform state list` confirms the numeric addresses.
2. Work out the mapping from the *old* config: `count` used the list order of `var.pedalos`, so index 0 was
   odette, 1 was odile, 2 was benno.
3. Record it in code, e.g. in `moves.tf`:
   ```hcl
   moved {
     from = random_pet.mascot[0]
     to   = random_pet.mascot["odette"]
   }
   # ... [1] -> "odile", [2] -> "benno"
   ```
4. `terraform plan` now says the mascots will be moved (no destroy). Apply; the IDs are unchanged and the
   next plan is clean.
