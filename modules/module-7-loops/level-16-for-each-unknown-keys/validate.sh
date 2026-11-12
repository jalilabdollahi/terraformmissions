#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_lacks 'for_each[^#]*random_id' "the instance keys must not be built from the run id"
tm_apply
RUN=$(tm_output_raw run_id)
[[ -n "$RUN" ]] || tm_fail "output run_id is empty"
for s in kelp-a kelp-b urchin-c; do
  tm_assert_in_state "local_file.label[\"$s\"]" "instances should be keyed by the plain sample name: local_file.label[\"$s\"]"
  tm_assert_file_equals "labels/$s-$RUN.txt" "Sample label $s-$RUN
" "labels/$s-$RUN.txt should carry the sample name and the run id"
done
n=$(find labels -type f | wc -l | tr -d ' ')
[[ "$n" == "3" ]] || tm_fail "expected 3 label files, found $n"
tm_assert_no_changes
# new samples: keys follow the names; the run id (and therefore existing labels) stays put
tm_plan_json -var 'samples=["kelp-a","kelp-b","urchin-c","sponge-d"]'
adds=$(jq -r '[.resource_changes[] | select(.change.actions == ["create"]) | .address] | sort | join(",")' "$TM_TMP/plan.json")
[[ "$adds" == 'local_file.label["sponge-d"]' ]] || tm_fail "a new sample should add exactly one label; plan creates: ${adds:-nothing}"
[[ -z "$(tm_plan_deletes)" ]] || tm_fail "adding a sample must not replace existing labels"
tm_pass "labels are keyed by sample name; the run id only appears in file names and content"
