#!/usr/bin/env bash
source "$TM_LIB"
# Build the works with the OLD flat code, then put the refactored tree back.
mkdir -p "$TM_TMP/new"
cp -R main.tf modules "$TM_TMP/new/"
rm -rf main.tf modules
cp "$LEVEL_PATH/legacy/main.tf" main.tf
cp -R "$LEVEL_PATH/legacy/modules" modules
tm_init "legacy init failed"
TM_MSG="legacy apply failed" tm_apply
hor=(h2 h1 h3)
for k in brass steel coil1 coil2; do tm_record "spring_$k" "$(tm_state_attr "random_id.spring_serial[\"$k\"]" hex)"; done
for i in 0 1 2; do tm_record "loads_${hor[$i]}" "$(tm_state_attr "random_integer.stall_loads[$i]" result)"; done
tm_record licence "$(tm_state_attr random_uuid.licence result)"
tm_record first_spin "$(tm_state_attr time_static.first_spin rfc3339)"
tm_record oil "$(tm_state_attr null_resource.oil_cycle id)"
tm_record demo "$(tm_state_attr random_integer.prototype_run result)"
for k in gold crimson; do tm_record "paint_$k" "$(tm_state_attr "module.paint.random_integer.coat[\"$k\"]" result)"; done
tm_record sheet_id "$(tm_state_attr local_file.works_sheet id)"
rm -rf main.tf modules
cp -R "$TM_TMP/new/main.tf" "$TM_TMP/new/modules" .
tm_init "init of the refactored tree failed"
