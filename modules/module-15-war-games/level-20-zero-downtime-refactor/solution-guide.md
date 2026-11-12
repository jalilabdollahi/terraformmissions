# Runbook - Pennywhistle Module Tree

1. **Triage.** The plan shows ten-plus destroys and as many creates. A refactor PR that changes only structure should plan
   to nothing, so each pair is an address change.
2. **Back up.** `cp terraform.tfstate terraform.tfstate.pre-tree`.
3. **Build the old-to-new table.** `terraform state list` against the modules:
   - `random_id.vat_serial["curd"...]` to `module.milkhouse.random_id.vat_serial` (one move for all four keys)
   - `random_integer.room_shelves[0..2]` to `module.caves.module.rooms.random_integer.shelves["f?"]`
   - `random_uuid.licence`, `time_static.first_churn` to `module.compliance`
   - `null_resource.cip_cycle` to `module.caves.terraform_data.cip_cycle`
   - `module.rennet` to `module.cultures`, and `random_integer.strain` to `strain_grams`
   - `random_integer.trial_batch` has no new home: a `removed` block.
4. **Resolve the index mapping.** Old order is not alphabetical: `terraform state show 'random_integer.room_shelves[0]'`,
   then find that capacity in `out/dairy-sheet.txt` (`room r2 <value>`). Repeat for 1 and 2.
5. **Write `moves.tf`** with nine `moved` blocks and the `removed` block (`lifecycle { destroy = false }`).
6. **Dry run.** `terraform plan` must list "has moved" lines, a "forgotten" note for the trial batch and no destroy. Any `will be
   created` line points at a missing move.
7. **Apply and verify.** Apply, `terraform state list` shows only module addresses plus `local_file.dairy_sheet`, and the next
   plan is clean; `out/dairy-sheet.txt` is untouched.
