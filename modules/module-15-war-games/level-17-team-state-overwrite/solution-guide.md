# Runbook - Fenwick Stale State

1. **Triage.** `terraform plan` wants to create `random_id.keeper_badge["cleo"]`, `random_integer.enclosure_slot["owls"]`
   and `random_integer.quarantine_bay`. Objects that exist are missing from state: the state is stale. Do not apply.
2. **Back up what is there.** `cp terraform.tfstate terraform.tfstate.overwritten`.
3. **Inventory the copies.**
   ```bash
   for f in terraform.tfstate terraform.tfstate.backup recovery/*.json; do
     echo "$f"; jq -r '"  lineage \(.lineage)  serial \(.serial)  resources \(.resources|length)"' "$f" 2>&1 | head -1
   done
   ```
   The live file has lineage L, serial 9. The CI artifact fails to parse (truncated). `rescue-hotline-service.json` has
   serial 40 but a different lineage. `fenwick-state-mon-0400.json` is serial 11, `fenwick-state-tue-1200.json` is serial 15,
   both lineage L; Tuesday's is the freshest valid one and holds all keepers and slots.
4. **Push it.** `terraform state push recovery/fenwick-state-tue-1200.json`: same lineage, higher serial, accepted without force.
5. **Account for what happened after it.** `recovery/ci-run-217-apply.log` shows the apply that created the quarantine bay and
   its failed upload: `[id=NN]`. Adopt: `terraform import random_integer.quarantine_bay "NN,1,60"` (the id format of
   random_integer is `result,min,max`).
6. **Apply and verify.** The only difference left is the missing `quarantine_bay` output; `terraform apply` writes it. A second plan is clean.
