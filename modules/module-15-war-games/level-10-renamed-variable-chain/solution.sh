#!/usr/bin/env bash
source "$TM_LIB"
terraform state pull > "$TM_TMP/before-rename.tfstate"
cp "$LEVEL_PATH/solution/main.tf" main.tf
cp "$LEVEL_PATH/solution/terraform.tfvars" terraform.tfvars
cp "$LEVEL_PATH/solution/modules/region/main.tf" modules/region/main.tf
terraform apply -auto-approve
