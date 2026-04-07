# State Partitioning

## What Was Broken
Config-b referenced `data.terraform_remote_state.infra.outputs.infra_id`, but config-a exports
its output as `infrastructure_id` — a different key name. This causes a runtime error when
config-b tries to access a non-existent key from the remote state.

## The Fix
Update the reference in config-b to use the correct output key: `infrastructure_id`.

## State Partitioning Benefits
Large Terraform configs are split into partitions (separate state files) for:
- **Blast radius reduction** — mistakes in the app layer cannot destroy core infrastructure
- **Faster operations** — each partition has fewer resources to plan and apply
- **Team autonomy** — different teams own different state partitions with independent lock cycles
- **Reduced state lock contention** — concurrent operations in different partitions don't block each other

## Output Contracts
`terraform_remote_state` creates an implicit API contract: the output key names. Treat them as
public, versioned API surface. Never rename outputs without coordinating with all consumers.

## Key Takeaway
Treat outputs from shared state as a public API. Document them, version them, and avoid renaming
them without updating all consumers. Consider using a wrapper module to abstract the contract.