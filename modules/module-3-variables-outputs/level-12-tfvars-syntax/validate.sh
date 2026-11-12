#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_file terraform.tfvars "terraform.tfvars should still hold the inputs"
tm_assert_config_lacks '"port_name"[[:space:]]*:' "terraform.tfvars is HCL, not JSON — JSON belongs in terraform.tfvars.json"
tm_assert_config_lacks 'default[[:space:]]*=' "the values must come from terraform.tfvars, not from defaults in the variable blocks"

tm_apply
tm_assert_output port "Port Calder"
tm_assert_output berths "14"
tm_assert_output_jq windows '. == ["05:10","17:25"]' "windows should be [05:10, 17:25]"
tm_assert_output_jq pilot_required '. == true' "pilot_required should be true"
tm_assert_file_contains notice/pilotage.txt "PILOTAGE NOTICE - PORT CALDER"
tm_assert_file_contains notice/pilotage.txt "Entry windows: 05:10 / 17:25"
tm_pass "terraform.tfvars is valid HCL and feeds all four variables"
