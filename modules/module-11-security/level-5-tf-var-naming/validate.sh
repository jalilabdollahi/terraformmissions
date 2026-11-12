#!/usr/bin/env bash
source "$TM_LIB"
SECRET="demo-not-a-real-secret-oar-4408"

tm_assert_config_has 'variable[[:space:]]+"boathouse_code"' "name the keypad variable boathouse_code (snake_case, no capitals)"
tm_assert_config_has 'variable[[:space:]]+"club_region"' "name the region variable club_region (underscores, not hyphens)"
tm_assert_config_lacks 'default[[:space:]]*=[[:space:]]*"demo-not' "no secret belongs in a default"

# 1. nothing set: required variables must be reported missing, not guessed
env -u TF_VAR_boathouse_code terraform plan -input=false -no-color >"$TM_LAST_OUT" 2>&1 </dev/null
[[ $? -ne 0 ]] || tm_fail "the plan succeeded with no keypad code supplied"

# 2. the exact environment a CI job would export
export TF_VAR_boathouse_code="$SECRET"
export TF_VAR_club_region="severn-north"
export TF_VAR_crew_roster='["stroke","cox","bow"]'
tm_apply
tm_assert_file_contains boathouse/keypad-code.txt "$SECRET" "the keypad code from TF_VAR_boathouse_code did not reach boathouse/keypad-code.txt"
tm_assert_file_contains boathouse/door-card.txt "Region: severn-north" "TF_VAR_club_region did not reach the door card"
tm_assert_file_contains boathouse/door-card.txt "Crew: stroke,cox,bow"
tm_assert_output crew_size 3
[[ "$(tm_file_mode boathouse/keypad-code.txt)" == "600" ]] || tm_fail "keypad-code.txt must stay mode 0600"
grep -qF -- "$SECRET" "$TM_LAST_OUT" && tm_fail "the code was printed during apply"
tm_assert_config_has 'sensitive[[:space:]]*=[[:space:]]*true' "the keypad variable must remain sensitive"
tm_assert_no_changes
tm_pass "all three TF_VAR_ environment variables are picked up by name"
