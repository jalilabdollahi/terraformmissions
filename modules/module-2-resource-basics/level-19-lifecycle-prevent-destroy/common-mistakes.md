# Common Mistakes

- **Leaving `prevent_destroy = true` in dev/test environments** — makes cleanup operations painful.
- **Thinking `prevent_destroy` protects against manual deletion** — it only blocks Terraform-managed destroys; manual deletion via cloud console still works.
- **Forgetting to remove it before intentionally decommissioning a resource** — the plan will always fail until the protection is lifted.