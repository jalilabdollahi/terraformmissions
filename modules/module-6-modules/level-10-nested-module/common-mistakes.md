# Common Mistakes

- **Using `path.root` in child modules** — almost always the wrong choice; use `path.module`.
- **Confusing `path.cwd` and `path.module`** — `path.cwd` is where `terraform` was invoked, not where the `.tf` file lives.