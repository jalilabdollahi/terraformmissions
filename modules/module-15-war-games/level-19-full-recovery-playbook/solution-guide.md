# Runbook - Aurelia Ice Camp Reset

1. **Triage order.** State first: `terraform plan` dies with a JSON parse error, so nothing else is visible.
   `jq . terraform.tfstate` fails; `jq '.serial,.lineage' terraform.tfstate.backup` works.
2. **Preserve evidence.** `cp terraform.tfstate terraform.tfstate.corrupt`, then restore:
   `cp terraform.tfstate.backup terraform.tfstate`. Same lineage, one serial older.
3. **Config cascade.** `terraform plan` now reports `Unsupported attribute: module.power.generator` and
   `module.comms.channel_number`. Fix the references to `generator_id` and `channel`. Plan again: the second layer appears,
   `Invalid value for input variable` (`generator_id` declared `number`, the value is a hex string). Declare `string`.
4. **What the plan wants now.** Create `module.power.random_integer.fuel_litres`, replace `terraform_data.beacon` (tainted),
   replace `module.comms.random_id.radio_key` (tainted) and rewrite `comms_sheet` (drift). Two of those are wrong.
5. **Re-adopt the fuel tank.** The backup predates it. `out/camp-manifest.txt` has `fuel NNN`:
   `terraform import module.power.random_integer.fuel_litres "NNN,200,900"`.
6. **Untaint what is healthy.** `terraform untaint module.comms.random_id.radio_key`. Keep the taint on the beacon: its last
   run printed `beacon FAILED`.
7. **Apply and verify.** The plan before applying shows two replacements: the beacon and the drifted sheet. After apply,
   `terraform plan` is clean, `out/beacon.txt` says `beacon OK`, and the sheet is rewritten.
