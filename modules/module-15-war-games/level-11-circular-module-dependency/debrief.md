# Circular Module Dependency — Incident Post-Mortem

## The Incident
Module A required Module B's output to compute its value, and Module B required Module A's
output to compute its value. Terraform's evaluation model requires a directed acyclic graph
(DAG) — cycles are fundamentally unsolvable because there is no valid evaluation order.

## The Fix
Extract the shared dependency (the seed value both modules need) to the root level. Both
modules receive the shared value as an input — the dependency arrows now both point from
root → module_a and root → module_b, with no cycle.

## Breaking Cycles — General Patterns

### Pattern 1: Extract to Root (used here)
Move the shared resource to the lowest common ancestor module.

### Pattern 2: Flatten the Modules
If two modules are tightly coupled, they should probably be one module.

### Pattern 3: Use Data Sources
If one side of the cycle can read its value from an external data source instead of
a module output, the cycle is broken.

## Detecting Cycles
```bash
terraform validate  # catches cycles immediately
terraform graph | grep -i cycle  # visual inspection
```

## Key Takeaway
Terraform module dependencies must form a Directed Acyclic Graph (DAG). If two modules
need to share data, that shared data belongs in a common ancestor, not in the modules
themselves. Circular dependencies are an architectural smell — refactor the module boundary.