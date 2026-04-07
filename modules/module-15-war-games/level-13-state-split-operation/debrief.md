# State Split Operation — Incident Post-Mortem

## The Incident
During a state split operation, resources 4 and 5 were removed from config-first to be
managed by config-second. Without `moved` blocks in config-first, Terraform interpreted
the removal as "these resources should be destroyed."

## The Fix
Add `moved` blocks in config-first with `from = to = <same address>`. This serves as a
declarative statement: "this resource is being deregistered from this config (not destroyed)."

## State Split Procedure
1. Add `moved` blocks in old config for resources being split out
2. Apply old config — resources are removed from its state, NOT destroyed
3. Import resources into new config (or apply new config fresh if resources don't exist yet)
4. Apply new config — resources are now managed by new config

## Alternative: terraform state mv
```bash
terraform state mv -state=old.tfstate -state-out=new.tfstate   random_string.res_4 random_string.res_4
```
This moves a resource's state entry from one state file to another. More precise than
`moved` blocks for cross-state migrations.

## Key Takeaway
State splits are high-risk operations. Always:
1. Back up both state files before the operation
2. Apply the old config (with moved blocks) before applying the new config
3. Verify both configs converge to a no-change plan after the split