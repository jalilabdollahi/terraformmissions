#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_has 'length\(' "the number of charts should be derived from the roster with length()"
tm_apply
tm_assert_output chart_total "5"
for pair in 0:tundra 1:juneau 2:kodiak 3:sitka 4:nome; do
  i=${pair%%:*}; s=${pair#*:}
  tm_assert_in_state "local_file.feeding_chart[$i]" "no feeding chart instance [$i] - one dog has no chart"
  tm_assert_file "charts/$s.txt" "charts/$s.txt is missing"
done
tm_assert_file_equals charts/nome.txt "Nome: 1.5 kg of fish-and-rice mix, twice a day
"
# roster grows: two new dogs must be planned as creates, nothing else
tm_plan_json -var 'dogs=["Tundra","Juneau","Kodiak","Sitka","Nome","Aspen","Denali"]'
creates=$(jq -r '[.resource_changes[] | select(.change.actions == ["create"]) | .address] | sort | join(",")' "$TM_TMP/plan.json")
[[ "$creates" == 'local_file.feeding_chart[5],local_file.feeding_chart[6]' ]] \
  || tm_fail "adding two dogs to the roster should add exactly two charts, plan creates: ${creates:-nothing}"
# roster shrinks: surplus charts must be removed, without errors
tm_plan_json -var 'dogs=["Tundra","Juneau"]'
deletes=$(tm_plan_deletes | sort | tr '\n' ' ')
[[ "$deletes" == 'local_file.feeding_chart[2] local_file.feeding_chart[3] local_file.feeding_chart[4] ' ]] \
  || tm_fail "with only two dogs, charts [2] to [4] should be deleted; plan deletes: ${deletes:-nothing}"
tm_pass "chart count follows the dog roster in both directions"
