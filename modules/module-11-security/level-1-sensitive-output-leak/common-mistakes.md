# Common Mistakes

- **Thinking `sensitive = true` encrypts state** — it only redacts CLI output, not state.
- **Forgetting to mark downstream outputs** — if a module outputs a sensitive value and a root
  module outputs it without `sensitive = true`, the protection is lost.
- **Using `random_string` instead of `random_password`** — `random_password` marks `result`
  as sensitive by default; `random_string` does not.