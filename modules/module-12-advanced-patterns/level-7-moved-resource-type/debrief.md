# Debrief: a moved block can change the resource type

Until Terraform 1.9 a `moved` block could only change the name or location of a resource. Since 1.9 it
can also change the type, as long as the provider says the move is supported. The built-in
`terraform_data` resource was designed as the replacement for `null_resource`, and the two schemas are
compatible: the ID stays and `triggers` becomes `triggers_replace`.

Why bother? `null_resource` lives in the hashicorp/null provider, an extra download that exists only to hold
a placeholder. `terraform_data` is built into Terraform, needs no provider, has `input`/`output` for
passing values, and supports `triggers_replace` for forced replacement. For new code it is the
recommended choice.

Two things trip people up. First, the argument names differ: copying the old block and just changing
the type gives "Unsupported argument". Second, the `null_resource` block has to disappear from the code: while it is still declared, the
moved block's source still exists and Terraform refuses the move.

Real-world takeaway: migrate placeholder resources with `moved`, not with destroy and create. Anything
that referenced the old ID (shot cards, tags, downstream systems) keeps working, and the plan shows `has moved to`.
