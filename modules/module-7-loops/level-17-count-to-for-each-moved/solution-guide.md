# Walkthrough - Painted On The Hull

1. `terraform plan` shows three `random_pet.mascot[...]` to destroy (numeric indexes) and three to create
   (`["padstow"]`, ...). `terraform state list` confirms the numeric addresses.
2. Work out the mapping from the *old* config: `count` used the list order of `var.stations`, so index 0 was
   padstow, 1 was sennen, 2 was penlee.
3. Record it in code, e.g. in `moves.tf`:
   ```hcl
   moved {
     from = random_pet.mascot[0]
     to   = random_pet.mascot["padstow"]
   }
   # ... [1] -> "sennen", [2] -> "penlee"
   ```
4. `terraform plan` now says the mascots will be moved (no destroy). Apply; the IDs are unchanged and the
   next plan is clean.
