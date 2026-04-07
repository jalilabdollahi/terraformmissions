# Common Mistakes

- **Overly restrictive character classes** — `[0-9a-f]` (hex only) vs `[A-Za-z0-9-]` (alphanumeric + hyphen).
- **Forgetting `can()` wrapper** — `regex()` throws an error if the pattern doesn't match; `can()` converts it to false.
- **Not testing with the actual default value** — always run `terraform validate` after writing a validation block.