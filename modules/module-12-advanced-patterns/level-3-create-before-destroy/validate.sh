#!/usr/bin/env bash
source "$TM_LIB"

OLD=$(tm_recall old_id)
[[ -n "$OLD" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'create_before_destroy[[:space:]]*=[[:space:]]*true' "the sign must never go dark: keep create_before_destroy"

# The plan must replace the board, new one first.
tm_plan_json
ORDER=$(jq -c '.resource_changes[] | select(.address=="local_file.billboard") | .change.actions' "$TM_TMP/plan.json")
# (on a repeated check the board is already replaced, so the plan is a no-op)
if [[ "$ORDER" == '["no-op"]' && "$(tm_state_attr local_file.billboard id)" != "$OLD" ]]; then ORDER='["create","delete"]'; fi
[[ "$ORDER" == '["create","delete"]' ]] || tm_fail "expected local_file.billboard to be replaced create-then-delete, plan says: $ORDER"

tm_apply

FN=$(tm_state_attr local_file.billboard filename)
[[ -n "$FN" ]] || tm_fail "local_file.billboard is not in state"
[[ -f "$FN" ]] || tm_fail "the billboard file '$FN' is missing after the replacement — the old board's deletion removed it"
tm_assert_file_equals "$FN" "ON THE BOARD: Sunrise Cereal Summer Sale"$'\n'

NOW=$(tm_state_attr local_file.billboard id)
[[ "$NOW" != "$OLD" ]] || tm_fail "the billboard board was not replaced"

# nothing stale may be left on disk
STALE=$(grep -rl 'Harvest Bank Mortgage Month' billboard 2>/dev/null)
[[ -z "$STALE" ]] || tm_fail "last week's board is still on disk: $STALE"

tm_assert_no_changes
tm_pass "the new board was written first and the old one removed without taking the sign down"
