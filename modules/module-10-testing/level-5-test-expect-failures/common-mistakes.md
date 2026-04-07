# Common Mistakes

- **Quoting the address** — `"var.port"` is a string, not a reference. Use `var.port` (no quotes).
- **Using `expect_failures` when no failure is expected** — the test will fail if the listed
  checks do NOT fail.
- **Wrong resource address** — use the full `resource_type.resource_name` form.