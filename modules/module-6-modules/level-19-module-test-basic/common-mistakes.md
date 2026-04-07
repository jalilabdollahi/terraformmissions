# Common Mistakes

- **`apply_all`** — not a valid command; always use `apply` or `plan`.
- **Missing `assert` block** — a `run` block without assertions is valid but provides no value.
- **Wrong file extension** — test files must end in `.tftest.hcl`, not `.tf`.