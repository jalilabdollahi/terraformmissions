#!/usr/bin/env bash
source "$TM_LIB"
mkdir -p "$TM_TMP/new"
cp -R main.tf modules "$TM_TMP/new/"
rm -rf main.tf modules
cp "$LEVEL_PATH/legacy/main.tf" main.tf
cp -R "$LEVEL_PATH/legacy/modules" modules
terraform init -input=false -no-color >/dev/null 2>&1
tm_apply
for n in alma brecon cullen dara emlyn; do
  tm_record "pet_$n" "$(tm_state_attr "module.roster.random_pet.member[\"$n\"]" id)"
done
rm -rf main.tf modules
cp "$TM_TMP/new/main.tf" main.tf
cp -R "$TM_TMP/new/modules" modules
exit 0
