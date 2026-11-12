# Debrief: aliases are names, and names must match

A provider block with an `alias` creates an additional, named configuration of the same provider.
Resources pick it with the `provider` meta-argument, written as `<provider>.<alias>` and, since
Terraform 0.12, as a bare reference rather than a string.

Two things went wrong here. The quoted form still parses, but it is deprecated and Terraform warns
about it because a future version will reject it. The typo is the worse problem: `random.south`
does not match any alias, so Terraform cannot find a configuration to run the resource with.

The alias is also recorded in state. Each resource entry carries the full provider address, for
example `provider["registry.terraform.io/hashicorp/random"].north_pit`. That is why you cannot
change a resource's alias without Terraform noticing, and why deleting an alias block while
objects still use it produces the odd "Provider configuration not present" error you saw.

With real clouds the pattern matters a great deal: one alias per region or per account, and a
typo means resources land in the wrong place or the plan refuses to run. Get in the habit of
reading the `provider` line of a resource the same way you read its name.
