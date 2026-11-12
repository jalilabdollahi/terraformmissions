# Debrief — providers flow down through a map, not through variables

A reusable module should not configure providers itself; it *declares* which it needs and lets the caller decide how
they are configured. By default a module inherits the root's default (un-aliased) configuration of each provider. The
moment it needs **more than one** configuration of the same provider — a primary and a mirror, two regions, two
accounts — it declares placeholders with `configuration_aliases`, and the caller fills them through the
`providers` argument.

The map reads right to left in meaning: the key is a name *inside the module*, the value is a configuration *in the
caller*. That is why `local.mirror = local.offsite` is not a typo. The same module can be used by one stack with
`offsite` and by another with `cold_storage`, and its code never changes.

Two gotchas matter in practice. First, writing a `providers` map turns inheritance off: list the default configuration
too, or the module has none. Second, the choice is recorded in **state**: every resource stores the provider
configuration that created it. Switching a resource to another configuration is therefore a real change that you can
see in `terraform state pull`, and for cloud providers it can mean the resource moves to a different account or region.

**Takeaway:** pass aliased providers explicitly with `providers = { module_name = root_configuration }`, remember to
include the default one, and confirm the wiring in state.
