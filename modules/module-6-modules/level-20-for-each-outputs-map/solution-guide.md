# Walkthrough — Yoga Room Prep Times

1. **Plan.**
   ```
   Error: Unsupported attribute
     on main.tf, in output "prep_minutes": value = module.classroom[*].minutes
     module.classroom is object with 4 attributes
     This object does not have an attribute named "minutes".
   ```
2. **Why.** `module.classroom` is an object whose attributes are the keys `vinyasa`, `hatha`, `yin`, `ashtanga`; each holds the module's
   outputs. `[*]` can't reach into the values of an object.
3. **Collect with `for`.**
   ```hcl
   value = { for style, m in module.classroom : style => m.minutes }
   ```
   and `sum([for m in module.classroom : m.minutes])` for the total.
4. Apply; try `-var 'classes={ashtanga=3,hatha=4}'` to confirm the total is 35. Then `check`.
