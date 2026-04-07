# count to for_each Migration

## What Was Broken
Switching from `count` to `for_each` changes resource addresses:
- `local_file.items[0]` → `local_file.items["alpha"]`
- `local_file.items[1]` → `local_file.items["beta"]`

Without `moved` blocks, Terraform sees these as entirely different resources (destroy old, create new).

## The moved Blocks
```hcl
moved {
  from = local_file.items[0]
  to   = local_file.items["alpha"]
}
moved {
  from = local_file.items[1]
  to   = local_file.items["beta"]
}
```

## After Adding moved
`terraform plan` should show no-op or only attribute-level updates (not destroy/create).

## Why This Matters
Destroying and recreating resources can have real-world consequences (downtime, data loss).
`moved` blocks let you refactor resource addressing without disrupting infrastructure.

## Concepts
- `moved` maps old addresses to new addresses in state
- One `moved` block per renamed instance