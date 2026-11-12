#!/usr/bin/env bash
source "$TM_LIB"
# Build the auction house the way it stood before the refactor: count-indexed, old list order.
mkdir -p "$TM_TMP/new"
cp main.tf variables.tf "$TM_TMP/new/"
cp "$LEVEL_PATH/legacy/main.tf" main.tf
cp "$LEVEL_PATH/legacy/variables.tf" variables.tf
tm_apply
lot=(C3 A1 B2 G7 D4 F6 E5)
docks=(out-1 in-1 in-2 out-2 in-3)
for i in 0 1 2 3 4 5; do
  tm_record "cart_CT-$((i+1))" "$(tm_state_attr "random_id.cart_serial[$i]" hex)"
done
for i in 0 1 2 3 4 5 6; do
  tm_record "lot_${lot[$i]}" "$(tm_state_attr "random_integer.lot_slot[$i]" result)"
done
for i in 0 1 2 3 4; do
  tm_record "gate_${docks[$i]}" "$(tm_state_attr "terraform_data.dock_door[$i]" id)"
done
tm_record licence "$(tm_state_attr random_uuid.ops_licence result)"
tm_record opening "$(tm_state_attr time_static.go_live rfc3339)"
tm_record manifest_id "$(tm_state_attr local_file.lot_manifest id)"
cp "$TM_TMP/new/main.tf" main.tf
cp "$TM_TMP/new/variables.tf" variables.tf
