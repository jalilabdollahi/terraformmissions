# Common Mistakes

- **Commenting out credentials instead of deleting them** — comments are still in the file and
  in git history.
- **Using `-backend-config` files without adding them to `.gitignore`**.
- **Rotating credentials but not removing the old ones from git history** — use `git filter-repo`
  or BFG Repo Cleaner to purge history after a credential leak.