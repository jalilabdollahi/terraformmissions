# Runbook - Nordhavn Orchid Reindex

1. **Triage.** `terraform plan` reports 20 to add and 20 to destroy. Read a few of the destroys:
   `random_id.cart_serial[0] will be destroyed (because random_id.cart_serial is not in configuration)`.
   The configuration changed names, not the auction house.
2. **Back up state.** `cp terraform.tfstate terraform.tfstate.pre-reindex` so a wrong move is reversible.
3. **List what state holds.** `terraform state list` shows the five old families: `random_id.cart_serial[0..5]`,
   `random_integer.lot_slot[0..6]`, `terraform_data.dock_door[0..4]`, `random_uuid.ops_licence`, `time_static.go_live`.
4. **Recover the old order.** The old lists were not alphabetical. `out/lot-manifest.txt` pairs names with values:
   `grep lot out/lot-manifest.txt`, then `terraform state show 'random_integer.lot_slot[0]'`. Match the number to the
   name. Do the same for the dock doors (their IDs are in the manifest too). The carts kept their order.
5. **Write the moved blocks** in `moves.tf`, one per address: 6 carts, 7 auction lots, 5 docks, 2 singletons.
6. **Dry run.** `terraform plan` must show 20 "has moved" lines, no destroy, and no update on the dock doors (an update means
   a door got the wrong name).
7. **Apply and verify.** `terraform apply`, then `terraform state list` shows only the new addresses and a second plan says
   "No changes". The manifest is untouched because every value is identical.
