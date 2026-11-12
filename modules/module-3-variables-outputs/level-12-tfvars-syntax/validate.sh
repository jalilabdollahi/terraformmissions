#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_file terraform.tfvars "terraform.tfvars should still hold the inputs"
tm_assert_config_lacks '"tour_name"[[:space:]]*:' "terraform.tfvars is HCL, not JSON — JSON belongs in terraform.tfvars.json"
tm_assert_config_lacks 'default[[:space:]]*=' "the values must come from terraform.tfvars, not from defaults in the variable blocks"

tm_apply
tm_assert_output tour "Calder Bay Whale Tours"
tm_assert_output seats "14"
tm_assert_output_jq sailings '. == ["08:30","14:15"]' "sailings should be [08:30, 14:15]"
tm_assert_output_jq lifejackets_required '. == true' "lifejackets_required should be true"
tm_assert_file_contains notice/sailing.txt "SAILING NOTICE - CALDER BAY WHALE TOURS"
tm_assert_file_contains notice/sailing.txt "Sailings: 08:30 / 14:15"
tm_pass "terraform.tfvars is valid HCL and feeds all four variables"
