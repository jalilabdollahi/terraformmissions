# Debrief - the dynamic label is a block type

A `dynamic` block is a template that *generates* repeated nested blocks. Its label is not a free name:
it must match the nested block type of the resource, here `source` inside `archive_file`. Terraform validates
the generated blocks against the provider schema, so a wrong label gives "Unsupported block type" even
though everything else looks right.

The label has a second job. Unless you set `iterator`, the loop variable is named after the label, so
inside `content { ... }` you read `source.key` and `source.value`. (The next mission explores how a custom
iterator changes that.) Renaming the label therefore needs the references renamed as well.

## Why dynamic exists

Nested blocks cannot take `for_each` directly: it is only available on resources, data sources, modules
and `dynamic`. When a provider models a list as repeated blocks - ingress rules, tags blocks, `source`
inputs of an archive - the only way to drive them from data is `dynamic`. The `content { ... }` block
inside describes what each generated block contains.

## Real-world takeaway

When a dynamic block fails with "Unsupported block type", open the provider docs and read the exact nested
block name, then compare it to the label character by character. Reach for `dynamic` only when the
number of blocks really varies; static blocks stay easier to read. The validator opened the zip file and
also planned with a different document map to prove the entries are generated from the variable, not
copied.
