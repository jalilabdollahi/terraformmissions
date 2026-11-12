#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_has 'setproduct\(' "build the combinations with setproduct()"
tm_apply
tm_assert_output booking_count "6"
for room in atrium garage loft; do
  for day in fri sat; do
    tm_assert_in_state "local_file.booking[\"$room/$day\"]" "missing instance local_file.booking[\"$room/$day\"]"
    tm_assert_file_equals "bookings/$room-$day.txt" "Room $room is booked for the hackers on $day.
"
  done
done
tm_assert_no_changes
# a third day adds one sheet per room and replaces nothing
tm_plan_json -var 'days=["fri","sat","sun"]'
adds=$(jq -r '[.resource_changes[] | select(.change.actions == ["create"]) | .address] | sort | join(",")' "$TM_TMP/plan.json")
[[ "$adds" == 'local_file.booking["atrium/sun"],local_file.booking["garage/sun"],local_file.booking["loft/sun"]' ]] \
  || tm_fail "a new day should add exactly one booking per room; plan creates: ${adds:-nothing}"
[[ -z "$(tm_plan_deletes)" ]] || tm_fail "adding a day must not delete existing bookings"
tm_pass "every room/day pair is its own keyed booking"
