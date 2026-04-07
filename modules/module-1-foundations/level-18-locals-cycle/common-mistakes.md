# Common Mistakes

- **Mutual locals** — two locals that each reference the other.
- **Three-node cycles** — A→B→C→A are harder to spot; run `terraform validate` to find them.
- **Cycle through resources** — `resource A` → `local X` → `resource A attr` — also a cycle.