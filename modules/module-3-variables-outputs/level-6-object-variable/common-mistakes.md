# Common Mistakes

- **Missing required object keys** — every non-optional key must be provided.
- **Wrong type for a key** — `port = "8080"` (string) fails when `port = number` is declared.
- **Forgetting `optional()` for truly optional keys** — available in Terraform >= 1.3.