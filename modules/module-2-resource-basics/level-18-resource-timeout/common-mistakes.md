# Common Mistakes

- **Using plain numbers for timeouts** — always include a unit suffix (`s`, `m`, `h`) inside quotes.
- **Forgetting quotes** — duration strings must be quoted; `10m` without quotes is parsed as `10 * m` which is invalid.
- **Not all resources support `timeouts`** — check the provider docs for which operations can be timed out.