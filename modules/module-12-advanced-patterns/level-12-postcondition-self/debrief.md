# Debrief: self is how a resource inspects itself

Terraform builds a dependency graph from references. If a resource's own lifecycle block referenced
`terraform_data.varnish_batch`, the resource would depend on itself, a cycle, so the language rejects it with
"Configuration for ... may not refer to itself".

`self` solves it for postconditions. It is bound to the object being checked and, unlike a normal reference,
carries computed attributes: values only known after the provider has created the object. The same
rule applies to `provisioner` and `connection` blocks, where `self` is the only way to read the
resource's own attributes.

Note what `self` is not available in. A `precondition` runs before the object exists, so there is
nothing to refer to; it should talk about inputs, variables and other resources. If you try `self` in a
precondition the language also rejects it. A good split: preconditions for "are the inputs sane?", postconditions
for "did the provider give me what I need?".

Postconditions are also evaluated when the object is read later. If a drifted value fails the rule, the next
plan reports the failure, which makes them a lightweight check on reality, not just on the first apply.

Real-world takeaway: if you find yourself writing a resource's own address inside its lifecycle block,
you want `self`.
