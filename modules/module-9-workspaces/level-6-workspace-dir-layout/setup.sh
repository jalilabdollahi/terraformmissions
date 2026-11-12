#!/usr/bin/env bash
source "$TM_LIB"
terraform workspace new summer >/dev/null || exit 1
tm_apply
tm_record summer_lineage "$(jq -r .lineage terraform.tfstate.d/summer/terraform.tfstate)"
terraform workspace new winter >/dev/null || exit 1
tm_apply
tm_record winter_lineage "$(jq -r .lineage terraform.tfstate.d/winter/terraform.tfstate)"
# The accident: the state file is pulled out of its workspace folder.
mv terraform.tfstate.d/winter/terraform.tfstate terraform.tfstate.d/winter.tfstate || exit 1
rm -f terraform.tfstate.d/winter/terraform.tfstate.backup
