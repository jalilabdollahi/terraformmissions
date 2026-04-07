# Common Mistakes

- **Wrong address in `from`** — must match exactly what `terraform state list` shows for the old resource.
- **Leaving `moved {}` in code forever** — remove it after the rename is deployed to all environments.
- **Using `moved {}` for cross-module moves incorrectly** — the syntax is slightly different for module moves.