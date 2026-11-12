# Debrief - one real object, one address

`terraform import` (and the `import` block) attach an existing object to an address in state. What neither does is check whether
the same object is already attached to *another* address. If you import the object a second time, say because someone forgot it was
already managed or used a temporary block, Terraform will track it twice. Each address keeps its own copy of the attributes, so
the two entries can drift apart, and the real danger is the cleanup: once the temporary block is removed from the code, the next
plan wants to destroy the orphaned address, which for real infrastructure destroys the one object both addresses point to.

The warning signs are in the plan, not in an error: a *destroy* of something that nobody deliberately removed, "(because X is
not in configuration)". Always read those lines before approving an apply.

How to diagnose:

- `terraform state list` shows every address Terraform knows.
- `terraform state show ADDRESS` (or `terraform show -json | jq`) prints each entry's ID; identical IDs mean a duplicate.
- Check whose configuration owns the object, because if a different state manages it too, you have two projects fighting
  over it.

How to fix: drop the surplus address with `terraform state rm`, or the declarative `removed { lifecycle { destroy = false } }`
block, so nothing in the real world is touched. Before any import, run `terraform state list | grep` for the object,
and prefer `import` blocks with `plan` reviews over ad-hoc CLI imports, which leave no trace in version control.
