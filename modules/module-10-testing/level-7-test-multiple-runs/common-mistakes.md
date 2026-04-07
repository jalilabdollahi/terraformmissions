# Common Mistakes

- **`run.<name>.output.<attr>`** — this namespace does not exist; use `output.<attr>` directly.
- **Assuming run blocks have isolated state** — they share the same test state by default.
- **Forgetting that prior runs affect state** — resources created in `run "first"` persist
  in state for `run "second"` unless explicitly destroyed.