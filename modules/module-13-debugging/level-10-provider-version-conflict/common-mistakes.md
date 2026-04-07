# Common Mistakes

- **Using `>=` without an upper bound** — `>= 2.5` allows any future version including potentially breaking major versions.
- **Forgetting to check child module constraints** — all modules share the same provider instance in a configuration.
- **Using exact pinning in modules** — prefer ranges in modules so callers have flexibility.