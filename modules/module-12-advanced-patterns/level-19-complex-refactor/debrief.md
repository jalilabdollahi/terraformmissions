# The Great Migration

## What Was Broken
All three `moved` blocks used unquoted identifiers as for_each keys:
- `local_file.service[web]` should be `local_file.service["web"]`
- `local_file.service[api]` should be `local_file.service["api"]`
- `local_file.service[worker]` should be `local_file.service["worker"]`

## The Fix
```hcl
moved {
  from = local_file.service[0]
  to   = local_file.service["web"]
}
moved {
  from = local_file.service[1]
  to   = local_file.service["api"]
}
moved {
  from = local_file.service[2]
  to   = local_file.service["worker"]
}
```

## count-to-for_each Migration Pattern
1. Keep existing count-based state (old instances at `[0]`, `[1]`, etc.)
2. Change resource to use `for_each` with a set/map
3. Add `moved` blocks for each instance: `from = resource[N]`, `to = resource["key"]`
4. Run `terraform plan` — should show 0 destroys, 0 creates

## Why It Matters
A failed count-to-for_each migration causes Terraform to destroy all count-indexed instances
and recreate them as for_each instances — potentially destroying production infrastructure.