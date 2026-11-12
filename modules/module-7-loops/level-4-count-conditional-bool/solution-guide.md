# Walkthrough - Lights On, Maybe

1. `terraform plan` stops with an `Invalid condition` style error pointing at
   `count = var.floodlights ? 1 : 0` (and the same problem in the notice's `? "ON" : "OFF"`).
2. Why: the ternary needs a boolean condition. `type = string` plus `"on"` is a string that cannot
   convert to bool.
3. Fix the *type*, not the comparison:
   ```hcl
   # variables.tf
   type = bool
   # terraform.tfvars
   floodlights = true
   ```
4. Apply: one `local_file.floodlight_schedule[0]` appears. Try `-var floodlights=false` to see the
   schedule scheduled for removal while the notice flips to OFF.
