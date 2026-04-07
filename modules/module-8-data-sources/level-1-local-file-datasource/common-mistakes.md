# Common Mistakes

- **Hardcoding absolute paths** — use `${path.module}/` to make paths relative to the config directory.
- **Forgetting data files** — if a `data "local_file"` references a file, that file must exist before `plan` or `apply`.
- **Confusing `resource "local_file"` with `data "local_file"`** — `resource` creates a file; `data` reads an existing one.