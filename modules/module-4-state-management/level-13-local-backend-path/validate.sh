#!/usr/bin/env bash
source "$TM_LIB"

TUKTUK=$(tm_recall tuktuk); MINUTE=$(tm_recall minute)
[[ -n "$TUKTUK" && -n "$MINUTE" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_file states/tuktuk-prod.tfstate "the production state file states/tuktuk-prod.tfstate has been removed"
tm_assert_config_has 'path[[:space:]]*=[[:space:]]*"states/tuktuk-prod.tfstate"' \
  "backend \"local\" in terraform.tf does not point at the production state file"
tm_assert_config_has 'backend[[:space:]]+"local"' "the local backend block was removed"

[[ -f .terraform/terraform.tfstate ]] || tm_fail "the backend has not been initialised"
INIT_PATH=$(jq -r '.backend.config.path // empty' .terraform/terraform.tfstate)
[[ "$INIT_PATH" == "states/tuktuk-prod.tfstate" ]] \
  || tm_fail "Terraform is still initialised against '$INIT_PATH' — the new backend path has not been activated"

tm_assert_in_state random_pet.tuktuk_name "the tuk-tuk is not in the active state"
[[ "$(tm_state_attr random_pet.tuktuk_name id)" == "$TUKTUK" ]] || tm_fail "the tuk-tuk name is not the original one"
[[ "$(tm_state_attr random_integer.departure_minute result)" == "$MINUTE" ]] || tm_fail "the departure minute is not the original one"

tm_assert_no_changes
tm_assert_file_contains timetable/morning.txt "$TUKTUK departs at minute $MINUTE" "the printed timetable does not match"
tm_pass "the backend reads states/tuktuk-prod.tfstate and tuk-tuk '$TUKTUK' departs at minute $MINUTE"
