# Debrief - instance counts must be known at plan time

Terraform plans in two stages of knowledge. During the plan every attribute is either *known* (it comes from your
configuration or from existing state) or *unknown* ("known after apply"). Most arguments may be unknown at plan time. A
few may not, because Terraform needs them to build the graph: `count`, `for_each` keys, `provider` configuration used by
a resource, and `depends_on`. If one of those depends on something computed by a provider, you get
`Invalid count argument` (or the matching `for_each` error).

The way to diagnose it is to ask of each reference in the `count` expression: *is this a value I wrote, or one a
provider invented?* `length(random_shuffle.panel.result)` looks innocent, but the list comes from the provider.

The standard repairs are:

- Count from the **input** that determines the size (what we did), or from another known value such as `length(var.list)`.
- Split the config in two applies (`-target` as a last resort, never as the design) when the count truly depends on
  something that must exist first. Prefer restructuring so that is not necessary.
- Use `for_each` over a map whose keys are known, and let the *values* be unknown.

Keep this rule in mind with data sources too: a `data` block that depends on a not-yet-created resource is deferred to
apply time, and anything computed from it is unknown at plan.
