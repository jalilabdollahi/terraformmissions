# Cascade Dependency Failure — Incident Post-Mortem

## The Incident
A single wrong attribute reference in the leaf module (module_a) caused a cascade validation
failure through the entire dependency chain (A → B → C). Modules B and C cannot be evaluated
because their inputs depend on module A's output, which cannot be computed.

## Root Cause
`random_string.value.id` in module_a — the attribute `id` does not exist; `result` is correct.

## Cascade Failure Debugging Strategy
1. **Read the full error output** — Terraform usually shows the originating module
2. **Find the leaf module** — the module with no `module.*` inputs is always the starting point
3. **Fix from the bottom up** — fixing the leaf fixes all downstream errors automatically
4. **Validate modules independently** — `cd modules/module_a && terraform validate`

## Dependency Graph Visualization
```bash
terraform graph | dot -Tsvg > graph.svg
```
This renders the dependency graph — useful for complex module chains.

## Preventing Cascade Failures
- **Module unit tests** — test each module in isolation (e.g. Terratest)
- **Validate in CI per module** — run `terraform validate` on each module directory
- **Type-safe outputs** — declare output types explicitly to catch mismatches early

## Key Takeaway
In a module dependency chain, a single wrong attribute in a leaf module blocks everything.
Always debug from the leaf (deepest dependency) outward. The error message is your guide.