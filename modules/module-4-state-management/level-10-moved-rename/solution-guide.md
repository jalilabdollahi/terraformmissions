# Walkthrough — Renamed Lift Passes

1. **See the damage.** `terraform plan` says `random_id.lift_pass will be destroyed` and
   `random_id.day_pass will be created`, and the same for the sign.
2. **List the old addresses.** `terraform state list` shows `random_id.lift_pass` and `local_file.gate_sign`.
3. **Write the moves** at the bottom of main.tf:
   ```hcl
   moved {
     from = random_id.lift_pass
     to   = random_id.day_pass
   }
   moved {
     from = local_file.gate_sign
     to   = local_file.turnstile_sign
   }
   ```
4. **Plan.** It now says `random_id.lift_pass has moved to random_id.day_pass` and `Plan: 0 to add, 0 to change, 0 to destroy`.
5. **Apply** to record the moves in state, then `terraform plan` once more. Type `check`.
