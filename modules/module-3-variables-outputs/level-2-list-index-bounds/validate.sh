#!/usr/bin/env bash
source "$TM_LIB"

tm_apply
tm_assert_output last_departure "17:30"
tm_assert_output sailings_per_day "4"
tm_assert_file_contains board/notice.txt "Last sailing:  17:30" "the notice board does not show 17:30 as the last sailing"
tm_assert_file_contains board/notice.txt "First sailing: 06:15" "the first sailing line is wrong"

# The summer timetable has 3 sailings: the notice board must follow the list, not a fixed position.
tm_plan_json -var 'departures=["07:00","11:00","15:45"]'
last=$(jq -r '.planned_values.outputs.last_departure.value' "$TM_TMP/plan.json")
[[ "$last" == "15:45" ]] || tm_fail "with a 3-sailing timetable the last departure is '$last' — it should be 15:45; the index must follow the list length"

tm_plan_json -var 'departures=["08:00","12:00","16:00","18:30","20:00"]'
last=$(jq -r '.planned_values.outputs.last_departure.value' "$TM_TMP/plan.json")
[[ "$last" == "20:00" ]] || tm_fail "with a 5-sailing timetable the last departure is '$last' — it should be 20:00"
tm_pass "the last sailing follows the end of the list, whatever its length"
