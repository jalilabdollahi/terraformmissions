# Zero-Downtime Full Refactor — Incident Post-Mortem

## The Incident
A comprehensive refactor simultaneously renamed 3 resources AND moved them into a new
module. Without `moved` blocks, Terraform planned to destroy the 3 original resources
and create 3 new ones inside the module — a 6-operation cycle that would cause downtime
for any stateful resources.

## The Fix
Add 3 `moved` blocks that each map an old root address to the new module + renamed address.
The `moved` block handles both the rename AND the module relocation in a single block.

## Composing moved Blocks for Complex Refactors
A single `moved` block can express a combined rename + relocation:
```hcl
moved {
  from = random_string.old_alpha          # old root address, old name
  to   = module.tokens.random_string.token_alpha  # new module address, new name
}
```

Terraform resolves this as: "the resource previously at `random_string.old_alpha` is now
at `module.tokens.random_string.token_alpha`". No destroy. No create. Just address update.

## Zero-Downtime Refactor Checklist
1. Plan the rename map before writing code
2. Write all moved blocks BEFORE changing resource names in the config
3. Run `terraform plan` — verify zero destroy operations
4. Apply
5. Run `terraform plan` again — verify it shows "No changes"
6. Remove moved blocks after all environments have been updated

## Key Takeaway
`moved` blocks compose naturally — they can express rename + module move in one block.
Zero-downtime refactors at any scale are possible with careful use of moved blocks.