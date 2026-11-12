# Walkthrough — Ashfall volcano monitoring post

1. **Diagnose.** `terraform validate` prints `Invalid default value for variable ... [1]: a number is required.`
   (position 1 is the string `"summit-vent"`). Position 0 would auto-convert to the string `"142.5"`, so
   Terraform only complains about the first element it cannot convert.
2. **Read the contract.** `tuple([string, number, bool])` means: first the station id, then the
   temperature, then the online flag.
3. **Fix the data, not the contract.** Reorder the default: `["summit-vent", 142.5, true]`.
4. **Verify.** `terraform output` shows `temp_c = 142.5` (a number) and `online = true`.
