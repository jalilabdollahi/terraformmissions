#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_has 'toset\(' "the list needs converting to a set with toset()"
tm_assert_config_has 'list\(string\)' "var.spices should stay a list(string)"
tm_apply
tm_assert_output tag_count "4"
for s in cardamom saffron sumac za-atar; do
  tm_assert_in_state "local_file.stall_tag[\"$s\"]" "no instance keyed \"$s\" - expected local_file.stall_tag[\"$s\"]"
  tm_assert_file "tags/$s.txt"
done
tm_assert_file_equals tags/sumac.txt "SUMAC - 4.50 per 100 g
"
n=$(tm_state_count)
[[ "$n" == "4" ]] || tm_fail "expected 4 tags in state (saffron is listed twice but is one tag), found $n"
# a different list: keys must follow the values
tm_plan_json -var 'spices=["paprika","paprika","sumac"]'
adds=$(jq -r '[.resource_changes[] | select(.change.actions == ["create"]) | .address] | sort | join(",")' "$TM_TMP/plan.json")
[[ "$adds" == 'local_file.stall_tag["paprika"]' ]] || tm_fail "a new spice should plan exactly one tag keyed by its name; plan creates: ${adds:-nothing}"
tm_pass "tags are keyed by spice name and duplicates collapse into one tag"
