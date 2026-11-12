#!/usr/bin/env bash
source "$TM_LIB"

tm_apply
tm_assert_output last_entry "17:30"
tm_assert_output entries_per_day "4"
tm_assert_file_contains board/gate.txt "Last entry:    17:30" "the gate board does not show 17:30 as the last entry slot"
tm_assert_file_contains board/gate.txt "First entry:   06:15" "the first entry slot line is wrong"

# The summer timetable has 3 entry slots: the gate board must follow the list, not a fixed position.
tm_plan_json -var 'entry_times=["07:00","11:00","15:45"]'
last=$(jq -r '.planned_values.outputs.last_entry.value' "$TM_TMP/plan.json")
[[ "$last" == "15:45" ]] || tm_fail "with a 3-slot timetable the last entry is '$last' — it should be 15:45; the index must follow the list length"

tm_plan_json -var 'entry_times=["08:00","12:00","16:00","18:30","20:00"]'
last=$(jq -r '.planned_values.outputs.last_entry.value' "$TM_TMP/plan.json")
[[ "$last" == "20:00" ]] || tm_fail "with a 5-slot timetable the last entry is '$last' — it should be 20:00"
tm_pass "the last entry slot follows the end of the list, whatever its length"
