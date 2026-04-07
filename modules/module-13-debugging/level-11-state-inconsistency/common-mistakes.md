# Common Mistakes

- **Copying state files between environments without adjustment** — state is environment-specific.
- **Sharing state files in version control** — use remote state backends instead.
- **Deleting state without understanding what it tracked** — you may lose track of real resources.