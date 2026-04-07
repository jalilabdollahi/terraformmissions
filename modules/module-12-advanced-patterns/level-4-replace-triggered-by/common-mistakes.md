# Common Mistakes

- **Referencing the wrong resource label** — copy the exact label from the `resource` declaration.
- **Confusing `replace_triggered_by` with `depends_on`** — `replace_triggered_by` causes replacement; `depends_on` only affects ordering.
- **Listing attributes instead of resources** — the list contains resource references, not attribute paths.