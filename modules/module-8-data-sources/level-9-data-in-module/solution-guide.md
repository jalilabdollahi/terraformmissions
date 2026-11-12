# Walkthrough — Canal Lock Watch

1. **Diagnose.** `terraform plan` reports `Unsupported attribute ... This object does not have an
   attribute named "level_cm"` for `module.north_lock`.
2. **Read the module's interface.** `modules/lock-notes/outputs.tf` declares one output, `reading`,
   an object with `keeper`, `level_cm` and `gates_open`. Inside the module the data source and
   `local.parsed` are private; the caller only sees outputs.
3. **Fix the callers.** Reference through the output:
   - `module.north_lock.reading.level_cm`
   - `module.south_lock.reading.level_cm` (not `water_level`)
   - `module.north_lock.reading.keeper`, `module.south_lock.reading.keeper`
4. `terraform apply` -> `lowest_level_cm = 148`, `open_gates = ["north"]`. Type `check`.
