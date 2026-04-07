# Common Mistakes

- **Numeric ID instead of string** — `id = 12345` vs `id = "12345"`.
- **Wrong ID format for the provider** — check provider docs for the exact format.
- **Using the resource name as ID** — the ID is a provider-side identifier, not the Terraform label.