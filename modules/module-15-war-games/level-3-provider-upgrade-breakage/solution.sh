#!/usr/bin/env bash
source "$TM_LIB"
terraform state pull > "$TM_TMP/pre-upgrade.tfstate"
terraform init -upgrade
terraform apply -auto-approve
