# Common Mistakes

- **Using wrong ID format for the resource type** — always check provider documentation for import syntax.
- **Importing to wrong resource address** — the `to` address must exactly match a resource in config.
- **Not running plan before apply for imports** — plan reveals ID errors before any state changes.
- **Removing import blocks before everyone applies** — keep import blocks until all team members have synced state.