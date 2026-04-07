# Cross-Team State Sharing

## What Was Broken
Team B referenced two output keys from Team A's remote state with incorrect names:
- `cluster_id` → should be `cluster_identifier`
- `vpc_id` → should be `network_id`

This is the most common failure in cross-team state sharing — the consuming team uses their
internal shorthand instead of the exact output name defined by the producing team.

## The Fix
Update Team B to use the exact output key names as defined in Team A.

## Establishing Output Contracts
Treat remote state outputs as a versioned API:
1. **Document all outputs** — use `description` on every shared output
2. **Create an interface doc** — a README in the state-producing config listing all outputs
3. **Never rename outputs without coordinating** — renaming breaks all consumers silently
4. **Consider a wrapper module** — a thin module that wraps the remote_state read, centralizing the contract in one place

## When Remote State Fails
If team-b can't access team-a's state:
- State file doesn't exist yet → team-a must apply first
- Wrong path → check backend config and relative path
- Key doesn't exist → verify against team-a's actual outputs (`terraform output` in team-a dir)

## Key Takeaway
Cross-team state sharing creates implicit coupling. Treat output key names as part of a
public API contract and manage them with the same care as external API changes.