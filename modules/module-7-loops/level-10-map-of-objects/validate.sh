#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_has 'each\.value\.(volunteer|boxes|time)' "read the object's attributes with each.value.<attribute>"
tm_apply
tm_assert_output total_boxes "40"
tm_assert_file_equals slips/early.txt "Slot early: Ines collects 12 boxes at 08:30
"
tm_assert_file_equals slips/noon.txt "Slot noon: Tomasz collects 8 boxes at 12:00
"
tm_assert_file_equals slips/sunset.txt "Slot sunset: Ravi collects 20 boxes at 18:45
"
tm_assert_no_changes
tm_plan_json -var 'slots={dawn={volunteer="Zoe",boxes=3,time="06:15"}}'
jq -e '[.resource_changes[] | select(.address == "local_file.pickup_slip[\"dawn\"]") | .change.after.content] == ["Slot dawn: Zoe collects 3 boxes at 06:15\n"]' \
  "$TM_TMP/plan.json" >/dev/null || tm_fail "a new slot should render its own volunteer, box count and time"
tm_pass "each slip reads volunteer, boxes and time from its slot object"
