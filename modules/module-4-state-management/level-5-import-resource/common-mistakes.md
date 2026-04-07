# Common Mistakes

- **Mismatched ID** — the import ID must exactly match the resource's real-world identifier.
- **Importing without a config block** — the resource must be declared in `.tf` files before importing.
- **Content mismatch after import** — after import, run `terraform plan` to see if attributes differ; you may need to adjust config to prevent unwanted changes.