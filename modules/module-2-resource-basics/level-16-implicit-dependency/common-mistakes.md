# Common Mistakes

- **Guessing attribute names** — always verify against provider docs or `terraform providers schema`.
- **Using `.path` on `local_file`** — the correct attribute is `.filename`.
- **Preferring `depends_on` over implicit attribute references** — implicit dependencies via attribute access are cleaner and self-documenting.