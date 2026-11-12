# Common mistakes

- **Removing `configuration_aliases` from terraform.tf.** Then the resources can no longer use `provider = local.vault`, and the mission checks the aliases are still declared.
- **Deleting the `providers = {...}` mapping.** It may still work by name matching, but the validator expects the vault run to map explicitly.
- **Adding a third provider block with the same alias.** Duplicates are rejected: `Duplicate provider block`.
- **Renaming the alias in `mint.tf` to `archive`.** The code's interface is `press` and `vault`; the test must adapt to it.
