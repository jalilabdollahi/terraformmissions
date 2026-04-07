# Common Mistakes

- **Referencing computed attributes across resources that depend on each other** — use `locals` for static values.
- **Using `depends_on` to "fix" cycles** — `depends_on` cannot break a data cycle, only order operations.
- **Confusing ordering with dependency** — `depends_on` affects ordering; attribute references create data dependencies.