# Common Mistakes

- **Putting prevent_destroy on the wrong resource** — this level's exact scenario; always double-check.
- **Forgetting to remove prevent_destroy when decommissioning** — the resource cannot be destroyed without removing it first.
- **Adding prevent_destroy to all resources "just in case"** — makes decommissioning painful and error-prone.
- **Confusing prevent_destroy with ignore_changes** — prevent_destroy blocks DESTROY; ignore_changes blocks UPDATE.