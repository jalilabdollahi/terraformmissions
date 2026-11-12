# Walkthrough — Stubai Ridge Day Pass

1. `terraform plan`: `Inconsistent conditional result types ... The 'true' value is tuple, but the
   'false' value is string.` That is `local.lifts`.
2. Fix it with a list on both sides: `["north"]`. Run plan again; now `terraform plan -var junior=false`
   fails with an invalid operand on the price multiplication (`"full"` is not a number).
3. Experiment:
   ```
   > true ? 0.5 : "full"      # "0.5"  (both branches forced to string!)
   > false ? 0.5 : "full"     # "full"
   > 80 * "full"              # error
   ```
   Fix: use `1` instead of `"full"`, so the factor is a number for every guest.
4. Apply and run `check` (it tries all combinations of the flags).
