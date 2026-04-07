# Common Mistakes

- **Referencing an undeclared alias** — every alias must have a matching `provider` block.
- **Forgetting the alias on the provider block** — `provider "local" {}` without `alias` is the default, not an alias.
- **Wrong syntax** — `provider = "local.primary"` (string) is wrong; use `provider = local.primary` (reference).