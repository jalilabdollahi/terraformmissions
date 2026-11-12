#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'split[[:space:]]*\(' "the waypoint strings must still be parsed with split()"
tm_assert_config_has 'join[[:space:]]*\(' "the signposts must still be built with join()"

tm_apply
tm_assert_output_jq stop_counts '. == {"Heron Way":3,"Quiet Loop":0}' \
  "stop_counts should be Heron Way = 3, Quiet Loop = 0 (blank pieces are not waypoints)"
tm_assert_output_jq signposts '. == {"Heron Way":"Oak Gate → Mill Ford → Stone Cross","Quiet Loop":"closed for walkers"}' \
  "signposts do not read as expected: Heron Way = 'Oak Gate → Mill Ford → Stone Cross', Quiet Loop = 'closed for walkers'"
tm_assert_file_equals signs/heron-way.txt "Heron Way: Oak Gate → Mill Ford → Stone Cross
"
tm_assert_file_equals signs/quiet-loop.txt "Quiet Loop: closed for walkers
"

# Same logic, other data.
tm_plan_json -var 'trails={"Tor Climb"=" Gate ,Cairn,  ,Summit ,,", "Empty One"=" , ,", "Solo"="Chapel"}'
jq -e '.planned_values.outputs.stop_counts.value == {"Tor Climb":3,"Empty One":0,"Solo":1}
  and .planned_values.outputs.signposts.value["Tor Climb"] == "Gate → Cairn → Summit"
  and .planned_values.outputs.signposts.value["Empty One"] == "closed for walkers"
  and .planned_values.outputs.signposts.value["Solo"] == "Chapel"' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "with other trail strings the counts or signposts are wrong (spaces, empty pieces and a lone waypoint must all be handled)"
tm_pass "waypoint strings are split, cleaned of blanks, counted and joined correctly"
