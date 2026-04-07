# Common Mistakes

- **Setting `length = 0`** — invalid; minimum is 1.
- **Using very short lengths for security tokens** — use at least 16 characters for tokens, 32+ for secrets.
- **Forgetting that `random_string.result` is stored in state** — it will be regenerated if you destroy and re-apply, potentially breaking things that depend on its stability.