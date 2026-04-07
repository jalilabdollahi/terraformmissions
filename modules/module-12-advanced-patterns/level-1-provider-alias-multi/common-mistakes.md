# Common Mistakes

- **Typo in alias name** — `local.wrong` instead of `local.primary`. Copy the exact alias string from the provider block.
- **Omitting the `provider` meta-argument** — when multiple aliased providers exist, Terraform uses the default (un-aliased) one. If there is no default, an error occurs.
- **Confusing `provider` (meta-argument) with `required_providers`** — these are different concepts.