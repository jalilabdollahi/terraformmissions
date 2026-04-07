# Common Mistakes

- **Forgetting the `data.` prefix** — `data.local_file.settings` requires all three parts.
- **Using quotes** — `target = "data.local_file.settings"` is a string, not a reference.
- **Mixing up `override_data` and `override_resource`** — data sources and managed resources have
  separate override block types.