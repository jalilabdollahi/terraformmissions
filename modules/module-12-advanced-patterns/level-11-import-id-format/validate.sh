#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'import[[:space:]]*\{' "the three values must be adopted with import blocks (or have been)"
tm_assert_config_has 'min[[:space:]]*=[[:space:]]*100' "random_integer.tag must keep its 100..999 range"
tm_assert_config_has 'max[[:space:]]*=[[:space:]]*999' "random_integer.tag must keep its 100..999 range"

tm_plan_json
BAD=$(jq -r '[.resource_changes[]? | select(.change.actions | index("delete")) | .address] | join(", ")' "$TM_TMP/plan.json")
[[ -z "$BAD" ]] || tm_fail "the plan would replace imported objects ($BAD): the imported value does not match the configuration"
tm_apply

[[ "$(tm_state_attr random_integer.tag result)" == "212" ]] || tm_fail "tag number is not 212: it was generated, not adopted"
[[ "$(tm_state_attr time_static.release rfc3339)" == "2025-04-12T06:30:00Z" ]] || tm_fail "release time is not 2025-04-12T06:30:00Z"
[[ "$(tm_state_attr random_id.nest b64_url)" == "Yd4Pxg" ]] || tm_fail "nest code is not Yd4Pxg"
[[ "$(tm_state_attr random_id.nest hex | wc -c | tr -d ' ')" == "9" ]] || tm_fail "the nest code should be a 4-byte id"

tm_assert_file_equals hatchery/certificate.txt "tag 212, released 2025-04-12T06:30:00Z, nest Yd4Pxg"$'\n'
tm_assert_no_changes
tm_pass "tag 212, release 2025-04-12T06:30:00Z and nest Yd4Pxg were adopted unchanged"
