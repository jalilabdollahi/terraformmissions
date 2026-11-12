#!/usr/bin/env bash
source "$TM_LIB"

OP=$(tm_recall operator); SILO=$(tm_recall silo); GAUGE=$(tm_recall gauge_sha); SHEET=$(tm_recall sheet_id)
[[ -n "$OP" && -n "$SILO" && -n "$GAUGE" && -n "$SHEET" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "random_pet" "combine_operator"' "the operator must keep its new name random_pet.combine_operator"
tm_assert_config_has 'resource "random_integer" "silo_number"' "the silo_number resource must stay in the configuration"
tm_assert_config_lacks 'resource[[:space:]]+"local_file"[[:space:]]+"retired_gauge_log"' "the retired gauge log must stay out of the configuration"
tm_assert_config_lacks '(moved|removed|import)[[:space:]]*\{' "this mission is done with the state CLI, not with moved, removed or import blocks"

# 1. rename
tm_assert_not_in_state random_pet.harvester "random_pet.harvester is still in state under its old name"
tm_assert_in_state random_pet.combine_operator "random_pet.combine_operator is not in state"
[[ "$(tm_state_attr random_pet.combine_operator id)" == "$OP" ]] || tm_fail "the operator name changed ('$OP' → '$(tm_state_attr random_pet.combine_operator id)')"

# 2. adoption
tm_assert_in_state random_integer.silo_number "random_integer.silo_number is still missing from state"
[[ "$(tm_state_attr random_integer.silo_number result)" == "$SILO" ]] || tm_fail "the silo number in state is '$(tm_state_attr random_integer.silo_number result)', the nameplate says $SILO"

# 3. forgetting without destroying
tm_assert_not_in_state local_file.retired_gauge_log "local_file.retired_gauge_log is still managed in state"
tm_assert_file gauges/retired-gauge-log.txt "gauges/retired-gauge-log.txt was deleted — the auditors needed it"
NOW=$(python3 -c 'import hashlib,sys; print(hashlib.sha1(open(sys.argv[1],"rb").read()).hexdigest())' gauges/retired-gauge-log.txt)
[[ "$NOW" == "$GAUGE" ]] || tm_fail "gauges/retired-gauge-log.txt was changed or recreated"

[[ "$(tm_state_attr local_file.dispatch_sheet id)" == "$SHEET" ]] || tm_fail "the dispatch sheet was rewritten"
tm_assert_no_changes
tm_pass "operator '$OP' renamed, silo $SILO re-adopted, gauge log forgotten but kept"
