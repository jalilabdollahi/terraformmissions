# Walkthrough — Mudflat Stage Contract

1. **Read the error.** `terraform plan` fails with `Unsupported attribute ... module.stage does not have an
   attribute named "stage_contract"` (lighting) and `"power_kw"` (rigging).
2. **Fix the producer** in `modules/stage/main.tf`:
   - `output "stage_contract"` returns `{ version, stage_id, power_budget_kw }`, with the version from
     `var.contract_version` (default "2.1").
   - `output "power_kw"` returns the same number and carries
     `deprecated = "Use stage_contract.power_budget_kw ..."`. Terraform then warns every consumer that
     still reads it, but nothing breaks.
   - Delete the loose outputs introduced by the tidy-up.
3. **Protect the consumer.** In `lighting.tf`:
   ```hcl
   lifecycle {
     precondition {
       condition     = startswith(module.stage.stage_contract.version, "2.")
       error_message = "lighting supports stage contract 2.x only ..."
     }
   }
   ```
4. **Check.** Apply works, and if you set `contract_version = "3.0"` on the module call, plan fails on the
   precondition instead of silently producing a wrong rig.
