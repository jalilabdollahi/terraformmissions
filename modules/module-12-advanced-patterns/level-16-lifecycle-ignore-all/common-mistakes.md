# Common Mistakes

- **Using `ignore_changes = all` as a quick fix for perpetual diffs** — find the root cause instead.
- **Not listing all attributes that need ignoring** — partial lists miss externally-managed fields.
- **Forgetting that `ignore_changes` doesn't prevent drift detection in plan** — it prevents Terraform from *fixing* drift, not from *reporting* it.