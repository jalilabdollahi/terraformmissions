# Moving in the Wrong Direction

## What Was Broken
The `moved` block had `from = local_file.new` and `to = local_file.old`. This tells Terraform
to look for `local_file.new` in state and rename it to `local_file.old`. But `local_file.old`
is not declared in the config — only `local_file.new` is. The direction was backwards.

## The Fix
```hcl
moved {
  from = local_file.old   # previous state address
  to   = local_file.new   # current config address
}
```

## moved Block Semantics
- `from`: the address that exists in the **current state** (before this change)
- `to`: the address in the **current config** (after this change)

## Why It Matters
A reversed `moved` block causes Terraform to plan a destroy+create instead of an in-place rename,
potentially losing production resources.