# Common mistakes

- **Passing only `local.mirror = local.offsite`.** Once a `providers` map exists, nothing is inherited implicitly, so the
  module's default `local` configuration must be listed as well.
- **Writing `provider = local.offsite` inside the child resource.** The module does not know about the root's alias; it only
  knows `local.mirror`.
- **Removing `configuration_aliases` and the `provider =` line.** Both copies are then written by the default provider,
  and the mission needs the mirror on the offsite configuration.
- **Putting a `provider` block inside the module.** That makes the module unusable with `count`, `for_each` or `depends_on`
  and is discouraged for reusable modules.
