# Common mistakes

- **Removing `provider = random.spare` from the child.** The error goes away, but the spare reel
  runs on the default configuration and the state check fails.
- **Only passing `providers = { random.spare = random.back_bench }`.** Terraform accepts it with an
  "undefined provider" warning, but the child never declared the slot, so validate is not clean.
- **Forgetting `random = random` in the map.** Once a `providers` map exists, the default
  configuration is no longer inherited automatically for that module call.
- **Declaring the alias in the root only.** `configuration_aliases` belongs to the module that
  receives the configuration, not the module that owns it.
