# Common Mistakes

- **Referencing non-existent resources in output `depends_on`** — same rules as resource `depends_on`.
- **Unnecessarily adding `depends_on` to outputs** — when the value references the resource, the dependency is already implicit.
- **Confusing `depends_on` with `precondition`** — they serve different purposes.