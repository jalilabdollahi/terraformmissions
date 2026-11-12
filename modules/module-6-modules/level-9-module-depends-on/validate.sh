#!/usr/bin/env bash
source "$TM_LIB"

# Start from a rink without any ice log, like a fresh checkout
rm -rf rink
rm -f terraform.tfstate terraform.tfstate.backup

tm_init
TM_MSG="terraform apply failed on a fresh checkout — who creates rink/ice-log.txt and who reads it?" tm_apply

tm_assert_in_state module.chiller.local_file.ice_log "the chiller no longer writes the log"
tm_assert_output resurface_after_min 50

# One apply must be enough for the schedule to follow the new ice
TM_MSG="terraform apply with a new thickness failed" tm_apply -var thickness_mm=30
tm_assert_output resurface_after_min 60
tm_apply -var thickness_mm=12
tm_assert_output resurface_after_min 24

tm_apply -var thickness_mm=25
tm_assert_output resurface_after_min 50
tm_assert_config_has 'depends_on[[:space:]]*=[[:space:]]*\[[^]]*module\.chiller' \
  "module.resurfacer must declare its dependency on module.chiller"
tm_assert_config_has 'data[[:space:]]+"local_file"' "the resurfacer has to keep reading the ice log from disk"
tm_assert_no_changes
tm_pass "the resurfacer waits for the chiller, so one apply is always enough"
