# Common Mistakes

- **Direct equality on sensitive values** — always fails; use structural checks instead.
- **Using `nonsensitive()` just to make the assertion work** — this defeats the security model.
- **Not testing sensitive outputs at all** — structural tests still validate that the value was
  produced and meets minimum requirements.