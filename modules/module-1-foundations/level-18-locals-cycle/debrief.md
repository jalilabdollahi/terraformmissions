# Circular Reference

## What Was Broken
`local.full_name` → `local.prefix` → `local.full_name` — a cycle with no resolution.
Terraform evaluates locals lazily using dependency ordering (topological sort). A cycle has no
valid ordering, so it's a hard error.

## Detecting Cycles
```
Error: Cycle: local.full_name, local.prefix
```
Terraform lists all the nodes in the cycle. Follow the arrows to find the loop.

## Fix Strategy
1. Identify which value *should* be the "base" (no dependencies on other locals)
2. Express it as a constant or pure expression using only `var.*`
3. Build derived locals from that base

```hcl
locals {
  prefix    = "svc"                              # base — no local deps
  full_name = "${local.prefix}-${var.base_name}" # derived — fine
}
```