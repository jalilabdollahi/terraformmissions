#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_assert_output film_count "3"
tm_assert_output_jq ticket_files 'type == "object" and (keys | sort) == ["night-ferry","paper-lanterns","salt-and-iron"]' \
  "ticket_files should be a map keyed by film slug"
tm_assert_output_jq ticket_files 'to_entries | all(.[]; . as $e | $e.value | endswith("tickets/" + $e.key + ".txt"))' \
  "each ticket_files value should be that film's ticket path"
tm_assert_config_has 'for[[:space:]]+[a-z_]+[[:space:]]*,[[:space:]]*[a-z_]+[[:space:]]+in[[:space:]]+local_file\.ticket' \
  "build the map with a for expression over local_file.ticket"
tm_plan_json -var 'screenings={"opening-gala"="20:00"}'
jq -e '.output_changes.ticket_files.after | keys == ["opening-gala"]' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "the output must follow the screenings variable (expected only opening-gala)"
tm_pass "ticket_files is a map of film slug to ticket path and follows the data"
