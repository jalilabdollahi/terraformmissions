# Common Mistakes

- **Referencing `resource_type.name` without an attribute** — always include the specific attribute name.
- **Using `.value` instead of `.result`** — the attribute name depends on the resource type; check the docs.
- **Interpolating objects directly into strings** — Terraform cannot automatically coerce an object to a string.