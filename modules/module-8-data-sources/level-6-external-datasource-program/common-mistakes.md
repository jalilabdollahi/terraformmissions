# Common Mistakes

- **Shell built-ins don't work** — `["echo", "{}"]` won't work as expected because `echo` is a shell built-in; use `/bin/echo` or a real script.
- **Relative paths without `path.module`** — Terraform runs from the working directory, which may differ from the module directory.
- **No PATH resolution in plan mode** — if `terraform plan` is run in an environment where the binary is not in PATH, it will fail.