# Common Mistakes

- **Using resource attributes on `self` in output conditions** — `self` in an output postcondition only has `value`.
- **Confusing `self` with the resource reference** — use the full reference path outside of condition blocks.
- **Missing `lifecycle` wrapper** — the `postcondition` block must be inside a `lifecycle` block.