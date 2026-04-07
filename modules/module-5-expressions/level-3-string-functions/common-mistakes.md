# Common Mistakes

- **Adding a global flag** — Terraform's `replace()` always replaces all matches; no flag needed.
- **Forgetting regex delimiters** — regex patterns must be wrapped in `/…/` to be treated as regex.
- **Confusing `replace()` with `regexreplace()`** — both work with regex; `regexreplace` is an alias.