# Common Mistakes

- **Not reading provider CHANGELOGs before upgrading** — breaking changes are documented there.
- **Using >= version constraints without upper bounds** — allows automatic major version upgrades with breaking changes.
- **Not testing provider upgrades in non-prod first** — breaking changes surface at the worst time in production.
- **Forgetting to update all usages** — if an attribute is renamed, it must be updated in all files and modules.