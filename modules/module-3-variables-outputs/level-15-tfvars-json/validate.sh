#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_file terraform.tfvars.json "terraform.tfvars.json is the booking system's export — it must stay"
[[ ! -e terraform.tfvars ]] || tm_fail "keep the export as terraform.tfvars.json; don't add a second terraform.tfvars next to it"
jq -e . terraform.tfvars.json >/dev/null 2>&1 || tm_fail "terraform.tfvars.json is not valid JSON"
jq -e '.site | type == "object" and has("lat") and has("lon")' terraform.tfvars.json >/dev/null 2>&1 \
  || tm_fail "in terraform.tfvars.json the 'site' value has to be a JSON object with lat and lon"
jq -e '.game_modes | type == "array"' terraform.tfvars.json >/dev/null 2>&1 || tm_fail "'game_modes' must be a JSON array"
tm_assert_config_lacks 'default[[:space:]]*=' "values must come from the JSON file, not from defaults"

tm_apply
tm_assert_output arena "Neon Rift"
tm_assert_output mode_count "2"
tm_assert_output arena_latitude "36.2"
tm_assert_output dome_vs_laser_dot "117551"
tm_assert_file_contains arena/sheet.txt "Neon Rift (36.2, -118.9)"
tm_assert_file_contains arena/sheet.txt "Modes: capture the flag, team deathmatch"
tm_pass "terraform.tfvars.json parses and every variable gets its proper type"
