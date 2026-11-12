# Common mistakes

- **Switching the module to `count`.** Splat then works, but the result is a list without voice names and the state addresses
  change; the mission keeps `for_each`.
- **Writing `values(module.section)[*].minutes`.** It collects a list, losing the voice names the map must keep.
- **Using `module.section.*.minutes`.** The legacy splat has the same limitation as `[*]`.
- **Hard-coding the four voices** in a map of references. New sections added through `var.sections` would be missing.
