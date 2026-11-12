# Walkthrough — Ranger Snow Patrol

1. **Diagnose.** `terraform plan` reports `Unsupported attribute ... This object does not have an
   attribute named "snow_cm"` for `module.north_trail`.
2. **Read the module's interface.** `modules/ranger-notes/outputs.tf` declares one output, `reading`,
   an object with `ranger`, `snow_cm` and `trail_open`. Inside the module the data source and
   `local.parsed` are private; the caller only sees outputs.
3. **Fix the callers.** Reference through the output:
   - `module.north_trail.reading.snow_cm`
   - `module.south_trail.reading.snow_cm` (not `snow_depth`)
   - `module.north_trail.reading.ranger`, `module.south_trail.reading.ranger`
4. `terraform apply` -> `lowest_snow_cm = 148`, `open_trails = ["north"]`. Type `check`.
