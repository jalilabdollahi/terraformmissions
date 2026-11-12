# Debrief — optional() puts defaults in the type

A module that accepts a structured input has a choice: require every attribute or let callers omit some. In an
`object({...})` type, an attribute is required unless you wrap it in `optional(type)` or `optional(type, default)`.
Without the default, a missing attribute becomes `null`; with it, Terraform substitutes the value while converting the
input, so the module's code can use `s.bitrate_kbps` as if every caller had written it.

Notice how this differs from the usual variable `default`. A `default = {...}` only applies when the *whole*
variable is omitted. Per-attribute defaults apply to every element, even when the caller supplies a partially filled
object, and that is the typical need for lists and maps of objects: queues, subnets, firewall rules, DNS records.

Two cautions. Defaults you put in the type are part of the module's public contract, so change them as carefully as
you would change a default in a resource. And an `optional()` attribute with no default is `null`, so expressions must
cope with it: `coalesce(s.bitrate_kbps, 128)` or `try()` are common companions when the real default depends on other
fields.

Keep truly mandatory attributes mandatory. `skill` has no sensible default, so leaving it out is better rejected at the
module boundary, with an error naming the queue, than discovered as a blank in the routing.

**Takeaway:** declare optional attributes with `optional(type, default)` in the module's variable type; keep required
attributes required, and never fill gaps in every caller.
