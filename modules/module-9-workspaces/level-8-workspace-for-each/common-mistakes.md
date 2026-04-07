# Common Mistakes

- **Omitting the `default` workspace** — new engineers often forget `default` is a real workspace.
- **Using `lookup()` without a default** — `lookup(map, key)` without a third argument panics on missing keys; add `lookup(map, key, fallback_value)`.
- **Assuming all workspaces are pre-known** — new workspaces can be created at any time; always handle unknown workspace names gracefully.