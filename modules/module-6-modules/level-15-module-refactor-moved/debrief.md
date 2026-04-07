# Renamed Module Without moved Block

## What Was Broken
Renaming `module "old"` to `module "new"` without a `moved` block causes Terraform
to see a new module (create) and a missing module (destroy).

## The moved Block
```hcl
moved {
  from = module.old
  to   = module.new
}
```
This instructs Terraform to update the state key from `module.old` to `module.new`,
preserving the existing resource without destroy/create.

## When to Use moved
- Renaming a module label
- Moving a resource into or out of a module
- Changing `count` to `for_each` (with appropriate key mapping)

## After Adding moved
`terraform plan` should show no changes (or only the changes you actually want).
The `moved` block can be removed in a later commit after the state migration is confirmed.

## Concepts
- `moved` block — declarative state migration
- Works for resources, module calls, and resource instances