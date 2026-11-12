# Common mistakes

- **Running `terraform apply -target=random_shuffle.panel` first.** It works once, but the config is still
  unplannable for the next person; the validator rejects `-target` in the config and plans from scratch.
- **Hard-coding `count = 3`.** The mission requires cards to follow `panel_size` (the validator plans with 4).
- **Replacing the shuffle with a fixed list.** Cards must show different flavours drawn by `random_shuffle`.
- **Wrapping the unknown in `try()`.** `try` cannot make an unknown value known; it only catches errors.
- **Using `length(var.something_else)` that is not tied to `result_count`.** Cards and shuffle would disagree about the
  panel size.
