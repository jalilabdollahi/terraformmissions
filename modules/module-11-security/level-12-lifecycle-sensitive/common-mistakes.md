# Common Mistakes

- **`ignore_changes = [all]`** — this is almost always wrong; it makes Terraform ignore all
  attribute drift for a resource.
- **Using `ignore_changes` to suppress noisy plan output** — fix the root cause instead.
- **Leaving `ignore_changes` in production configs from dev experiments** — review lifecycle
  blocks in code reviews for security resources.