# Emergency State Surgery — Incident Post-Mortem

## The Incident
A resource type migration was performed (from `random_id` to `random_string`) but the old
state entry for `random_id.legacy_id` was never cleaned up. Terraform's state now records
a resource type that doesn't exist in the config, and the config has a new resource type
that isn't in state.

## The Fix
1. `terraform state rm random_id.legacy_id` — remove the stale entry
2. `terraform apply` — create `random_string.service_token` fresh

## What `terraform state rm` Does
- Removes the resource from the state file
- Does NOT destroy the underlying infrastructure
- The resource becomes "unmanaged" — Terraform no longer tracks it
- Next plan/apply will treat the resource as "to be created" (since it's missing from state)

## When to Use State Surgery
- **Type migration**: changing resource type requires removing old state entry
- **Import failure**: wrong import left bad state entry
- **Manual creation**: resource created outside Terraform but not imported
- **Orphaned state**: resource deleted outside Terraform, state not updated

## Key Takeaway
`moved` blocks handle ADDRESS changes (rename, module move). For TYPE changes, you must
use `terraform state rm` + fresh apply (or import if the infrastructure still exists).
`moved` blocks cannot change a resource's type.