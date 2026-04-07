# Common Mistakes

- **Renaming without moved blocks** — always the most dangerous refactoring mistake.
- **Wrong direction in moved block** — `from` must be the OLD address, `to` must be the NEW address.
- **Partial moved blocks** — missing even one rename causes that resource to be destroyed and recreated.
- **Removing moved blocks before all environments are updated** — keep them until all workspaces are applied.