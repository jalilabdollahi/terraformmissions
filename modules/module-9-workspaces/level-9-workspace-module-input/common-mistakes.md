# Common Mistakes

- **Missing `default` key** — the most common oversight; always include `default` as a fallback.
- **Passing `terraform.workspace` directly to modules** — modules should not need to know about workspaces; translate at the root level.
- **Inconsistent env names** — agree on a convention (`dev`/`stg`/`prd` vs `development`/`staging`/`production`) and stick to it.