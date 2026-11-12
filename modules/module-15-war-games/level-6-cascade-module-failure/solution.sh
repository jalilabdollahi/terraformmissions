#!/usr/bin/env bash
source "$TM_LIB"
terraform state pull > "$TM_TMP/before-release.tfstate"
terraform apply -auto-approve
