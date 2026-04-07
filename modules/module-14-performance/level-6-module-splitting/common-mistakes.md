# Common Mistakes

- **Forgetting moved blocks during refactoring** — the leading cause of accidental destroy in module splits.
- **Wrong module address format** — use `module.<name>.<type>.<label>`, not just `<type>.<label>`.
- **Removing moved blocks too early** — wait until all team members have run the refactored plan.
- **Using moved blocks for cross-state moves** — moved only works within the same state file; use state mv for cross-state.