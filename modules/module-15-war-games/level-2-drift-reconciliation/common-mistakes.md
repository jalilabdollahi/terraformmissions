# Common Mistakes

- **Not running plan before fixing** — plan shows all drifts at once, preventing partial fixes.
- **Fixing drift in state instead of config** — use `terraform state` commands only for structural changes, not attribute fixes.
- **Accepting infrastructure drift without review** — always review what -refresh-only will commit to state.
- **Not automating drift detection** — schedule regular plan runs in CI to catch drift early.