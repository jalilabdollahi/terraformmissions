# Runbook - Hollowbrook Saffron Consolidation

1. **Triage.** `terraform plan` in `stacks/all-in-one` would create nine objects: nothing exists in its state. Three source
   states must be merged, all with the same addresses.
2. **Inventory.** In `stacks/fields` and `stacks/drying`, `terraform state list` shows three resources plus a remote-state
   lookup. In `stacks/packing` the default workspace is empty: `terraform workspace list` reveals `autumn`; its state is
   `stacks/packing/terraform.tfstate.d/autumn/terraform.tfstate`.
3. **Back up** all four state locations (`cp -R stacks stacks.bak` before touching anything).
4. **Move with a module prefix** (nine moves):
   ```bash
   terraform state mv -state=stacks/fields/terraform.tfstate -state-out=stacks/all-in-one/terraform.tfstate \
     random_id.batch module.fields.random_id.batch
   ```
   repeat for `random_integer.quota` and `local_file.ledger`, then for drying, then for packing (its autumn state file).
5. **Plan the merged stack.** Two lines say `random_integer.quota must be replaced` (drying and packing): the hand-written
   `quota_max`/`quota_min` values differ from `stacks/drying` (50..120) and `stacks/packing` (40..90). Fix the module calls.
6. **Apply** (records the module outputs), and plan again: no changes.
7. **Retire** the old team code (`stacks/*/main.tf`) so nobody applies it against empty state.
