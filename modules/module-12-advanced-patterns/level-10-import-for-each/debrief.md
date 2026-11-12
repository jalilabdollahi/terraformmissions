# Debrief: one import block, many objects

Adopting a dozen objects used to mean a dozen `import` blocks or a shell loop around `terraform import`.
Since Terraform 1.7 an import block can have `for_each`, with `each.key` and `each.value` available in
`to` and `id`. When a resource itself uses `for_each` over a map, the pairing is natural: the same map
supplies the resource instances, the instance keys in `to`, and the provider IDs in `id`.

The expressions in an import block have limits. `to` must resolve to a single resource instance address, and
`id` must be known at plan time, so you can use variables, locals, and functions like `format` or
`lookup`, but not attributes of other resources. If your IDs are not in the same shape as the keys, build
a local map first and iterate over that.

Notice what the plan tells you in the broken version: three creations. For real infrastructure that
would be three duplicates and a quota alert. For a `random_integer` it is silent: the numbers are just
different. That is why the validator compares each ticket with the paper copy.

Real-world takeaway: for bulk adoption, drive the resource and the import from one data structure, review
the summary line for "to import, 0 to add", and delete the import blocks in a later cleanup commit.
