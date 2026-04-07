# Common Mistakes

- **Referencing a resource that doesn't exist** — same problem; always check the exact label.
- **Overusing depends_on** — prefer data-driven dependencies (referencing outputs) over explicit `depends_on` when possible.