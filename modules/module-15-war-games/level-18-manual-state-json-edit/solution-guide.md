# Runbook - Kestrel Valley Truffle Hand Edit

1. **Triage.** `terraform plan` fails immediately:
   `Resource instance managed by newer provider version ... random_id.hound_tag["..."]`. The provider is fine; the state claims it was
   written by a newer one. Terraform cannot even run `state list`, so CLI-only fixes are blocked.
2. **Back up first.** `cp terraform.tfstate terraform.tfstate.pre-edit` and write down `jq '.lineage,.serial' terraform.tfstate`.
3. **Inspect.** `jq '.resources[] | {type, module, instances: [.instances[] | {index_key, schema_version}]}' terraform.tfstate`
   shows `schema_version: 7` on the random_id and random_integer instances. Provider schema version is 0.
4. **Edit 1.** Set those `schema_version` values to 0. Run `terraform plan`: now it loads, but wants to destroy
   `random_id.hound_tag[0]` ... and create `random_id.hound_tag["bruno"]` ...: the instances carry `index_key` 0..3, not names.
5. **Edit 2.** Map positions back to names by value, not by guess: `out/inspection-log.txt` lists `hound <name> <hex>` and
   `quota <grove> <value>`. For every instance, look up its `attributes.hex` / `attributes.result` and set `index_key`
   to that name (for the module's integers too).
6. **Revision discipline.** Keep `lineage`, add 1 to `serial`, write the file (valid JSON, same structure).
7. **Verify.** `terraform plan` shows no changes; `terraform state list` shows only named instances; the inspection log is untouched.
