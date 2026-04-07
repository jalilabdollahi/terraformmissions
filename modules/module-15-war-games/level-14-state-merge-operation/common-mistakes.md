# Common Mistakes

- **Adding resources to merged config without moved blocks** — Terraform creates duplicates.
- **Forgetting to transfer state entries** — moved blocks alone don't move state; use terraform state mv too.
- **Not decommissioning the source config** — leaves orphaned state entries that cause future confusion.
- **Wrong state file paths in state mv command** — double-check the -state and -state-out paths.