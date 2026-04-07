# Common Mistakes

- **Hardcoding `/tmp/` paths with non-existent parents** — intermediate directories are not created automatically.
- **Expecting `local_file` to `mkdir -p`** — it does not; only the file itself is created.
- **Confusing `path.root` with `path.module`** — for single-module configs they are the same, but they differ when using child modules.