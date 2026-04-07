# Common Mistakes

- **Reusing iterator names in nested loops** — always use unique names for each nesting level.
- **Omitting `iterator` on nested dynamic blocks** — the default name is the block type, which may collide.
- **Forgetting to update inner references** after renaming the outer iterator.