# Debrief: modules declare the provider slots they need

A child module normally inherits the default configuration of every provider it uses, with no
code at all. That convenience stops at aliases. If a module wants a second configuration of a
provider (a replica region, a second account, here a back wall), it has to say so with
`configuration_aliases` inside its own `required_providers`. The module author is publishing an
interface, just like for variables and outputs.

The caller fills that interface with the `providers` argument of the `module` block. The left
side of each pair is the name the module uses, the right side is the root's configuration. You also have to pass the default
`random = random` explicitly once you pass a `providers` map; a map replaces the implicit
inheritance, it does not add to it.

A subtle trap: if you only pass the map and forget the declaration, Terraform 1.x is lenient and
merely prints "Reference to undefined provider". That warning is a bug waiting to happen when
the module is published. If you do not pass anything at all, as here, you get the confusing
"provider configuration not present" error.

Real-world takeaway: reusable multi-region modules should always declare their aliases, and
validate output should be warning-free before the module is tagged.
