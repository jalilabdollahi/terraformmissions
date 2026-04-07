# Common Mistakes

- **Trying to use moved blocks for type changes** — moved blocks are for address changes only.
- **Deleting state without removing infrastructure first** — the real resource becomes unmanaged.
- **Not backing up state before surgery** — always: `terraform state pull > backup.tfstate` first.
- **Assuming state rm destroys infrastructure** — it does NOT; it only removes the state tracking entry.