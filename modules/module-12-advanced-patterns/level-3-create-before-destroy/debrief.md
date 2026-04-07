# Name Collision on Replacement

## What Was Broken
Both `local_file.config_a` and `local_file.config_b` pointed to the same `filename = "shared.txt"`.
With `create_before_destroy = true`, Terraform creates the new instance before deleting the old one.
When the filename is the same, the new instance collides with the existing file.

## The Fix
Give each resource a unique filename so they do not compete for the same path.

## create_before_destroy Semantics
- Normally: destroy old → create new
- With `create_before_destroy`: create new → destroy old (requires unique identifiers)

## Why It Matters
`create_before_destroy` is useful for avoiding downtime but requires that new resources can coexist
with old ones momentarily. Static, shared identifiers break this invariant.