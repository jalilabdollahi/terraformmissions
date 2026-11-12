# Runbook - Pennywhistle Carousel Module Tree

1. **Triage.** The plan shows ten-plus destroys and as many creates. A refactor PR that changes only structure should plan
   to nothing, so each pair is an address change.
2. **Back up.** `cp terraform.tfstate terraform.tfstate.pre-tree`.
3. **Build the old-to-new table.** `terraform state list` against the modules:
   - `random_id.spring_serial["brass"...]` to `module.movements.random_id.spring_serial` (one move for all four keys)
   - `random_integer.stall_loads[0..2]` to `module.stables.module.stalls.random_integer.loads["f?"]`
   - `random_uuid.licence`, `time_static.first_spin` to `module.compliance`
   - `null_resource.oil_cycle` to `module.stables.terraform_data.oil_cycle`
   - `module.paint` to `module.finishes`, and `random_integer.coat` to `coat_grams`
   - `random_integer.prototype_run` has no new home: a `removed` block.
4. **Resolve the index mapping.** Old order is not alphabetical: `terraform state show 'random_integer.stall_loads[0]'`,
   then find that load rating in `out/works-sheet.txt` (`stall h2 <value>`). Repeat for 1 and 2.
5. **Write `moves.tf`** with nine `moved` blocks and the `removed` block (`lifecycle { destroy = false }`).
6. **Dry run.** `terraform plan` must list "has moved" lines, a "forgotten" note for the prototype run and no destroy. Any `will be
   created` line points at a missing move.
7. **Apply and verify.** Apply, `terraform state list` shows only module addresses plus `local_file.works_sheet`, and the next
   plan is clean; `out/works-sheet.txt` is untouched.
