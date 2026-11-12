# Walkthrough — Willowmere Zoo

1. **Diagnose.** `terraform validate` returns errors for three outputs:
   - `Unsupported attribute ... no attribute named "capacity"` (savanna_capacity)
   - `Unsupported attribute ... no attribute named "keeper"` (aviary_lead_keeper)
   - `Invalid index ... the given key does not identify an element in this collection value` (reptile_head_keeper)
2. **Map the structure.** `habitats` is `map(object({ diet, enclosure = object({ capacity, keepers }) }))`.
   Path = key → `.enclosure` → `.capacity` / `.keepers[n]`.
3. **Fix each path.**
   - `var.habitats["savanna"].enclosure.capacity`
   - `var.habitats.aviary.enclosure.keepers[0]`
   - `var.habitats["reptile_house"].enclosure.keepers[0]`
4. **Verify.** `terraform output`: 12, Mei, Omar, 60. `terraform console` lets you explore `var.habitats` interactively.
