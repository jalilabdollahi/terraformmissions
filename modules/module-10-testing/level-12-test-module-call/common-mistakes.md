# Common Mistakes

- **Using `..` when the module is a subdirectory** — if the module is *inside* the project, use
  `./subdir`, not `../subdir`.
- **Forgetting `terraform init` after changing source** — the module cache must be updated.
- **Using absolute paths** — these work locally but break in CI. Always use relative paths.