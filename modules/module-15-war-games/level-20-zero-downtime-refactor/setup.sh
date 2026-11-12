#!/usr/bin/env bash
source "$TM_LIB"
# Build the dairy with the OLD flat code, then put the refactored tree back.
mkdir -p "$TM_TMP/new"
cp -R main.tf modules "$TM_TMP/new/"
rm -rf main.tf modules
cp "$LEVEL_PATH/legacy/main.tf" main.tf
cp -R "$LEVEL_PATH/legacy/modules" modules
tm_init "legacy init failed"
TM_MSG="legacy apply failed" tm_apply
fer=(r2 r1 r3)
for k in curd whey cold1 cold2; do tm_record "vat_$k" "$(tm_state_attr "random_id.vat_serial[\"$k\"]" hex)"; done
for i in 0 1 2; do tm_record "shelves_${fer[$i]}" "$(tm_state_attr "random_integer.room_shelves[$i]" result)"; done
tm_record licence "$(tm_state_attr random_uuid.licence result)"
tm_record first_churn "$(tm_state_attr time_static.first_churn rfc3339)"
tm_record cip "$(tm_state_attr null_resource.cip_cycle id)"
tm_record demo "$(tm_state_attr random_integer.trial_batch result)"
for k in bluemould brie; do tm_record "rennet_$k" "$(tm_state_attr "module.rennet.random_integer.strain[\"$k\"]" result)"; done
tm_record sheet_id "$(tm_state_attr local_file.dairy_sheet id)"
rm -rf main.tf modules
cp -R "$TM_TMP/new/main.tf" "$TM_TMP/new/modules" .
tm_init "init of the refactored tree failed"
