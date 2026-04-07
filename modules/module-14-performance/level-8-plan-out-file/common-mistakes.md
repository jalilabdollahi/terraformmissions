# Common Mistakes

- **min_* values summing to more than length** — a common random_string misconfiguration that only surfaces at plan time.
- **Not using plan files in CI/CD** — allows drift between plan review and apply execution.
- **Storing plan files in unencrypted storage** — plan files can contain sensitive values in plain text.
- **Applying stale plan files** — plan files become invalid if state changes between plan and apply.