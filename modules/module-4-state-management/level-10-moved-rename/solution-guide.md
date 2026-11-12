# Walkthrough — Renamed Zip Passes

1. **See the damage.** `terraform plan` says `random_id.zip_pass will be destroyed` and
   `random_id.climb_pass will be created`, and the same for the sign.
2. **List the old addresses.** `terraform state list` shows `random_id.zip_pass` and `local_file.gate_sign`.
3. **Write the moves** at the bottom of main.tf:
   ```hcl
   moved {
     from = random_id.zip_pass
     to   = random_id.climb_pass
   }
   moved {
     from = local_file.gate_sign
     to   = local_file.harness_sign
   }
   ```
4. **Plan.** It now says `random_id.zip_pass has moved to random_id.climb_pass` and `Plan: 0 to add, 0 to change, 0 to destroy`.
5. **Apply** to record the moves in state, then `terraform plan` once more. Type `check`.
