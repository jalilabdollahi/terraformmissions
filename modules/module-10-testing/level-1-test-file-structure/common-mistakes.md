# Common Mistakes

- **`tests {}` instead of `run {}`** — the block that defines a test scenario is `run`, not `tests`.
- **Confusing `.tftest.hcl` with regular `.tf` files** — test files have their own block vocabulary.
- **Missing the run block label** — `run "name_here"` requires a quoted label string.