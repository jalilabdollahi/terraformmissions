# Common Mistakes

- **Referencing non-existent resources in `depends_on`** — Terraform validates all references at parse time.
- **Overusing `depends_on`** — when attribute references exist, implicit dependencies are preferred and clearer.
- **Forgetting that `depends_on` is a list** — the value must be wrapped in `[...]`.