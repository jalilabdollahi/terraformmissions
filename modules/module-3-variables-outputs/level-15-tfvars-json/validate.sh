#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_file terraform.tfvars.json "terraform.tfvars.json is the booking system's export — it must stay"
[[ ! -e terraform.tfvars ]] || tm_fail "keep the export as terraform.tfvars.json; don't add a second terraform.tfvars next to it"
jq -e . terraform.tfvars.json >/dev/null 2>&1 || tm_fail "terraform.tfvars.json is not valid JSON"
jq -e '.site | type == "object" and has("lat") and has("lon")' terraform.tfvars.json >/dev/null 2>&1 \
  || tm_fail "in terraform.tfvars.json the 'site' value has to be a JSON object with lat and lon"
jq -e '.instruments | type == "array"' terraform.tfvars.json >/dev/null 2>&1 || tm_fail "'instruments' must be a JSON array"
tm_assert_config_lacks 'default[[:space:]]*=' "values must come from the JSON file, not from defaults"

tm_apply
tm_assert_output observatory "Kestrel Peak"
tm_assert_output instrument_count "2"
tm_assert_output dome_latitude "36.2"
tm_assert_output light_gathering_vs_eye "117551"
tm_assert_file_contains dome/sheet.txt "Kestrel Peak (36.2, -118.9)"
tm_assert_file_contains dome/sheet.txt "Instruments: camera, spectrograph"
tm_pass "terraform.tfvars.json parses and every variable gets its proper type"
