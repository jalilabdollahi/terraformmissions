# Common Mistakes

- **Mutual references** — if A needs data from B and B needs data from A, you have a cycle. Use locals or break the dependency.
- **Wrong address in state rm** — the address must match exactly what `terraform state list` shows.
- **Confusing `state rm` with destroy** — `state rm` only removes tracking; the actual file stays on disk.