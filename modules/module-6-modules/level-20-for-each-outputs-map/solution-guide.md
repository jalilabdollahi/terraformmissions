# Walkthrough — Choir Rehearsal Slots

1. **Plan.**
   ```
   Error: Unsupported attribute
     on main.tf, in output "rehearsal_minutes": value = module.section[*].minutes
     module.section is object with 4 attributes
     This object does not have an attribute named "minutes".
   ```
2. **Why.** `module.section` is an object whose attributes are the keys `soprano`, `alto`, `tenor`, `bass`; each holds the module's
   outputs. `[*]` can't reach into the values of an object.
3. **Collect with `for`.**
   ```hcl
   value = { for voice, m in module.section : voice => m.minutes }
   ```
   and `sum([for m in module.section : m.minutes])` for the total.
4. Apply; try `-var 'sections={bass=3,alto=4}'` to confirm the total is 35. Then `check`.
