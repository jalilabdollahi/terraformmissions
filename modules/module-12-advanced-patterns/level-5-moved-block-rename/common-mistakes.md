# Common Mistakes

- **Swapping from/to** — `from` is the old name in state, `to` is the new name in config.
- **Forgetting the `moved` block entirely** — without it, Terraform plans a destroy+create.
- **Using `moved` for type changes** — `moved` only handles address changes, not resource type changes.