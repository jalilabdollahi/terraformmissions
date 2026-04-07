# Common Mistakes

- **Assuming `create_before_destroy` is always safe** — it requires unique resource identifiers.
- **Using a static shared name** — if two resources share the same unique identifier, a collision is unavoidable.
- **Forgetting that `local_file` is filesystem-backed** — the filename IS the unique identifier for the provider.