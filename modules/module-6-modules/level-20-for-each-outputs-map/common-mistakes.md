# Common mistakes

- **Switching the module to `count`.** Splat then works, but the result is a list without style names and the state addresses
  change; the mission keeps `for_each`.
- **Writing `values(module.classroom)[*].minutes`.** It collects a list, losing the style names the map must keep.
- **Using `module.classroom.*.minutes`.** The legacy splat has the same limitation as `[*]`.
- **Hard-coding the four styles** in a map of references. New classes added through `var.classes` would be missing.
