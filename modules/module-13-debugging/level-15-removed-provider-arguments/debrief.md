# Debrief - major upgrades remove things

A provider's major version number is a promise: *this release may break your configuration*. Arguments get removed, renamed or turned
into read-only (computed) attributes, defaults change, resources are split. The tls provider's move from 3.x to 4.0 is a typical example:
`key_algorithm` (and `ca_key_algorithm`) used to be required inputs duplicating information that was already in the key; in 4.x the
provider reads it from the key, so setting it is an error.

A safe upgrade routine:

1. **Read the upgrade guide / changelog** for every major version you cross. The registry page of the provider has an "Upgrade guide" tab.
2. Change the constraint, run `terraform init -upgrade`, then `terraform validate`. Removed arguments show up here, without touching
   any infrastructure.
3. Use the schema as an oracle: `terraform providers schema -json` tells you whether an attribute is `required`, `optional` or `computed`.
4. Run `terraform plan` and read it as carefully as an apply. Some upgrades change defaults that turn into in-place updates or replacements
   even when the configuration validates.

This is also why constraints like `~> 3.4` exist: pinning to a major version keeps surprises out until you choose to upgrade. And why you commit
`.terraform.lock.hcl`: the upgrade should be a reviewed diff, not something that happens on a colleague's machine.

Here the existing key stayed untouched, because the migration only removed redundant input arguments. Always confirm that with the plan.
