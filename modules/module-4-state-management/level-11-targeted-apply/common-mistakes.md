# Common Mistakes

- **Referencing nonexistent attributes** — know your resource's exported attributes from provider docs.
- **Overusing `-target`** — it can leave state inconsistent; use sparingly and follow up with a full apply.
- **Assuming dependency order** — Terraform creates resources in dependency order; explicit `depends_on` is only needed when there's no attribute reference.