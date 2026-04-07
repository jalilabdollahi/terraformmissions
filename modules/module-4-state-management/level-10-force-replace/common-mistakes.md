# Common Mistakes

- **Forgetting to update triggers** — if you update what the resource does but not the trigger, it won't re-run.
- **Using `terraform taint` (deprecated)** — prefer `terraform apply -replace` in modern Terraform.
- **Triggers on dynamic values** — triggers that reference computed values (like resource IDs) may cause unintended replacements.