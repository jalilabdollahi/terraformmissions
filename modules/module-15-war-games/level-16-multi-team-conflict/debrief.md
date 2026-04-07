# Multi-Team Conflict — Incident Post-Mortem

## The Incident
Team 2 referenced an output key `network_token` from Team 1's remote state, but Team 1
actually exports the output as `infra_token`. This mismatch is a classic multi-team
coordination failure — each team uses different naming conventions internally.

## The Fix
Update Team 2's reference from `network_token` to `infra_token`.

## Multi-Team Governance Patterns

### Output Registry / Catalog
Maintain a shared document or code registry listing all cross-team state outputs:
```
team1/
  outputs:
    - infra_token: "Infrastructure token for app layer"
    - cluster_id: "Kubernetes cluster identifier"
```

### Interface Module Pattern
Create a shared "interface" module that wraps the remote_state read:
```hcl
# modules/team1-interface/main.tf
data "terraform_remote_state" "team1" { ... }
output "infra_token" {
  value = data.terraform_remote_state.team1.outputs.infra_token
}
```
All teams consume this module instead of reading remote state directly.
Renames only need to be updated in one place.

### Change Management
- Treat output renames as breaking changes
- Communicate via PR/change request before renaming
- Provide deprecation period with both old and new names

## Key Takeaway
Cross-team remote state creates coupling. Centralize the coupling in an interface module,
document all shared outputs, and treat output names as a versioned public API.