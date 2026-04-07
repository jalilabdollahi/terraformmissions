# State Merge Operation — Incident Post-Mortem

## The Incident
During a config merge (consolidating two configs into one), the merged config did not have
`moved` blocks for resources coming from config-beta. Terraform planned to create `beta_token`
from scratch, which would cause a new resource to be created while the old one in config-beta's
state became orphaned.

## The Fix
Add a `moved` block in config-merged for `beta_token`. Pair with `terraform state mv` to
physically transfer the state entry from beta.tfstate to merged.tfstate.

## Full State Merge Procedure
```bash
# 1. Add moved blocks to config-merged for all resources from config-beta
# 2. Transfer state entries
terraform state mv   -state=config-beta/beta.tfstate   -state-out=config-merged/merged.tfstate   random_string.beta_token random_string.beta_token

# 3. Remove resources from config-beta (or delete config-beta entirely)
# 4. Apply config-merged — should show no destroy, no create (clean convergence)
terraform -chdir=config-merged apply
```

## Key Takeaway
State merges are inverse state splits. The `moved` block documents intent; `terraform state mv`
transfers the actual state entry. Both are required for a clean zero-downtime merge.