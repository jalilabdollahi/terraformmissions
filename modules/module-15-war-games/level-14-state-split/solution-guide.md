# Runbook - Halcyon Float Stack Breakup

1. **Triage.** Read `SPLIT-PLAN.md`: three stacks, no re-issuing, remote state between them. Open each scaffold next to
   `monolith/main.tf` and list the mapping: warehouse gets the dock key, rider capacity, two float serials; krewes gets the
   sign-up namespace, bead series and bead ledger; lighting gets `rig_key` (now `light_key`), the controllers and the cue sheet.
2. **Freeze and back up.** `cp monolith/terraform.tfstate monolith/terraform.tfstate.pre-split`. Nobody applies in
   `monolith/` any more.
3. **Move warehouse.**
   ```bash
   terraform state mv -state=monolith/terraform.tfstate -state-out=warehouse/terraform.tfstate random_id.dock_key random_id.dock_key
   # same for random_integer.rider_capacity and random_id.float_serial (moves both instances)
   ```
4. **Publish warehouse outputs.** `cd warehouse && terraform apply`. The plan should only add outputs; resources stay as they are.
5. **Move krewes**, add the missing `output "gold_series"` to `krewes/main.tf`, then `terraform apply` there.
6. **Move lighting**, renaming on the way:
   `terraform state mv ... random_id.rig_key random_id.light_key`, plus `terraform_data.controller` and `local_file.cue_sheet`.
   `terraform apply` in `lighting/`.
7. **Empty the monolith.** `jq '.resources|length' monolith/terraform.tfstate` is 0; delete the resource code in
   `monolith/*.tf`.
8. **Verify.** `terraform plan` in each of the three stacks reports no changes.
