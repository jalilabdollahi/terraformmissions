#!/usr/bin/env bash
source "$TM_LIB"
terraform state pull > "$TM_TMP/before-v2.tfstate"
cp "$LEVEL_PATH/solution/main.tf" main.tf
cp "$LEVEL_PATH/solution/modules/roster/moved.tf" modules/roster/moved.tf
terraform apply -auto-approve
