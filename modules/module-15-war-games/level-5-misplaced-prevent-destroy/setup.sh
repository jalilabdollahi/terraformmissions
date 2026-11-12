#!/usr/bin/env bash
source "$TM_LIB"
# The yard ran for months with the annex enabled.
cp terraform.tfvars "$TM_TMP/tfvars.new"
echo 'annex_enabled = true' > terraform.tfvars
tm_apply
tm_record charter_id "$(tm_state_attr random_id.yard_charter id)"
tm_record berth_tag "$(tm_state_attr 'module.annex[0].random_pet.berth_tag' id)"
cp "$TM_TMP/tfvars.new" terraform.tfvars
exit 0
