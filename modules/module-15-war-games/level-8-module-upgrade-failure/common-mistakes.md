# Common Mistakes

- **Not pinning module versions** — unpinned modules can automatically pick up breaking changes.
- **Not searching all callers before renaming** — grep for the old output name across all configs.
- **Renaming outputs without deprecation period** — always provide a deprecation window for callers.
- **Not testing module upgrades in non-prod** — breaking changes are expensive when discovered in production.