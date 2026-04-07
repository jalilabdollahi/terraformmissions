# Incomplete Destroy — Ghost Resources — Incident Post-Mortem

## The Incident
A previous destroy operation was interrupted after removing the infrastructure for
`resource_ghost_a` and `resource_ghost_b`, but before Terraform could update the state file.
The resources are gone from the real infrastructure but still recorded in state — "ghost" entries.

## The Problem
On the next apply:
- If Terraform plans to destroy ghosts: the destroy call will fail (resources don't exist)
- If left in state: Terraform keeps trying to manage non-existent resources

## The Fix: removed {} Block (Terraform >= 1.7)
```hcl
removed {
  from = random_string.resource_ghost_a
  lifecycle {
    destroy = false  # don't call the API, just remove from state
  }
}
```

## Alternative: terraform state rm (older Terraform)
```bash
terraform state rm random_string.resource_ghost_a
terraform state rm random_string.resource_ghost_b
```

Both approaches remove the resource from state. The `removed {}` block is declarative and
reviewable; `terraform state rm` is imperative and leaves no trace in the config.

## Key Takeaway
`removed {}` blocks are the modern, declarative way to remove orphaned state entries. They
are code-reviewable, committed to VCS, and idempotent. Prefer them over `terraform state rm`
in team environments.