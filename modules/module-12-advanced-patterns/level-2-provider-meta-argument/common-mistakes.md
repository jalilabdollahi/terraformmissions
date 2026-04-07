# Common Mistakes

- **Quoting the provider reference** — `"local.primary"` is treated as a string, not a provider reference.
- **Using interpolation** — `"${local.primary}"` is also incorrect; the value must be an unquoted reference.