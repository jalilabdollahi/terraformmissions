#!/usr/bin/env bash
source "$TM_LIB"
# Rebuild the pre-release world: legacy modules, applied for real.
mkdir -p "$TM_TMP/new"
cp -R main.tf modules "$TM_TMP/new/"
rm -rf main.tf modules
cp "$LEVEL_PATH/legacy/main.tf" main.tf
cp -R "$LEVEL_PATH/legacy/modules" modules
terraform init -input=false -no-color >/dev/null 2>&1
tm_apply
for b in B1 B2 B3 B4; do tm_record "belt_$b" "$(tm_state_attr "module.belts.random_id.belt[\"$b\"]" id)"; done
for s in transfer arrivals; do tm_record "pet_$s" "$(tm_state_attr "module.sorters.random_pet.sorter[\"$s\"]" id)"; done
# The release lands on main.
rm -rf main.tf modules
cp "$TM_TMP/new/main.tf" main.tf
cp -R "$TM_TMP/new/modules" modules
exit 0
