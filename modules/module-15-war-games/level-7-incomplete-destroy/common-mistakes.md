# Common Mistakes

- **Letting Terraform plan destroy ghosts** — destroy calls fail for non-existent resources, breaking the pipeline.
- **Not using lifecycle { destroy = false }** — without it, removed blocks attempt to destroy the resource.
- **Using terraform state rm in CI** — it leaves no VCS trace; use removed {} blocks instead.
- **Not investigating WHY ghosts exist** — find and fix the root cause (interrupted destroy, manual delete) to prevent recurrence.