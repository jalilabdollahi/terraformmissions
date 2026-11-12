# Debrief — Alder Hollow Seed Vault

**What broke.** HCL distinguishes two constructs that look alike. An *attribute* assigns a value: `name = value`.
A *block* nests structured settings: `name { ... }`, optionally with labels. Which one a name is depends on the
schema, not on your taste. `required_providers` (inside `terraform`) and `lifecycle` (inside a resource) are
blocks, so writing `= {` turns them into attributes assigned an object value, and Terraform replies with
"Unsupported argument" and a helpful "did you mean to define a block" hint.

**Why the confusion is easy.** In JSON or YAML, nested objects are just keys. In HCL, an object literal
`{ a = 1 }` is also valid syntax, but only where the schema expects an attribute of object type. Tags and
`for_each` maps are attributes (use `=`); `lifecycle`, `provisioner`, `dynamic`, `connection`, `ingress`
and `root_block_device` are blocks (no `=`).

**What the lifecycle block does here.** `ignore_changes = [content]` tells Terraform to stop comparing
`content` with the configuration after creation, so a weekly inspector name change does not rewrite the
label. The validator proves it by planning with a different inspector and expecting no changes.

**Real-world takeaway.** When Terraform says "Unsupported argument" for a name that you know exists in the
documentation, check whether the docs list it under "Arguments" or under a nested "Block" heading. Use `dynamic`
blocks, not `for` expressions, when you need to generate blocks from data.
