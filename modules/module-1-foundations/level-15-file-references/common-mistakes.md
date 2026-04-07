# Common Mistakes

- **Wrong directory depth** — `templates/nginx.conf.tpl` requires a `templates/` subdirectory.
- **Forgetting `path.module`** — bare relative paths like `"nginx.conf.tpl"` depend on cwd, which changes in CI.
- **Using `file()` instead of `templatefile()`** — `file()` doesn't substitute variables.