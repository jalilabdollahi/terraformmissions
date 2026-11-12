#!/usr/bin/env bash
source "$TM_LIB"
mkdir -p "$TM_TMP/new"
cp -R main.tf variables.tf terraform.tfvars modules "$TM_TMP/new/"
rm -rf main.tf variables.tf terraform.tfvars modules
cp "$LEVEL_PATH/legacy/main.tf" main.tf
cp "$LEVEL_PATH/legacy/variables.tf" variables.tf
cp "$LEVEL_PATH/legacy/terraform.tfvars" terraform.tfvars
cp -R "$LEVEL_PATH/legacy/modules" modules
terraform init -input=false -no-color >/dev/null 2>&1
tm_apply
tm_record beacon "$(tm_state_attr module.region.module.post.random_id.beacon id)"
tm_record channel "$(tm_state_attr module.region.random_integer.channel result)"
rm -rf main.tf variables.tf terraform.tfvars modules
cp -R "$TM_TMP/new/." .
exit 0
