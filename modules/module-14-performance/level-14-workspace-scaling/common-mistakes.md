# Common Mistakes

- **Inconsistent separators** — mixing underscores and dashes in different parts of the same name.
- **Wrong component order** — environment last makes filtering by environment much harder.
- **Forgetting terraform.workspace in some resource names** — some resources named, others not.
- **Using workspaces for true prod isolation** — workspaces share the same state backend and blast radius.