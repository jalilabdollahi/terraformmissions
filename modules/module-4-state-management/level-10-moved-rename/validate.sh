#!/usr/bin/env bash
source "$TM_LIB"

PASS=$(tm_recall pass_id); SIGN=$(tm_recall sign_id)
[[ -n "$PASS" && -n "$SIGN" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "random_id" "day_pass"' "the resource must keep its new name random_id.day_pass"
tm_assert_config_has 'resource "local_file" "turnstile_sign"' "the resource must keep its new name local_file.turnstile_sign"
tm_assert_config_lacks 'resource[[:space:]]+"random_id"[[:space:]]+"wave_pass"' "the old name random_id.wave_pass came back"
tm_assert_config_lacks 'resource[[:space:]]+"local_file"[[:space:]]+"entrance_sign"' "the old name local_file.entrance_sign came back"

tm_assert_config_has 'from[[:space:]]*=[[:space:]]*random_id\.wave_pass' "no moved block starts from random_id.wave_pass"
tm_assert_config_has 'to[[:space:]]*=[[:space:]]*random_id\.day_pass' "no moved block points to random_id.day_pass"
tm_assert_config_has 'from[[:space:]]*=[[:space:]]*local_file\.entrance_sign' "no moved block starts from local_file.entrance_sign"
tm_assert_config_has 'to[[:space:]]*=[[:space:]]*local_file\.turnstile_sign' "no moved block points to local_file.turnstile_sign"

tm_assert_not_in_state random_id.wave_pass "the old address random_id.wave_pass is still in state — a moved block takes effect on apply"
tm_assert_not_in_state local_file.entrance_sign "the old address local_file.entrance_sign is still in state — apply the moves"
tm_assert_in_state random_id.day_pass "random_id.day_pass is not in state yet"
tm_assert_in_state local_file.turnstile_sign "local_file.turnstile_sign is not in state yet"

[[ "$(tm_state_attr random_id.day_pass id)" == "$PASS" ]] || tm_fail "the day-pass code changed — the sold wristbands are void"
[[ "$(tm_state_attr local_file.turnstile_sign id)" == "$SIGN" ]] || tm_fail "the turnstile sign was recreated"

tm_assert_no_changes
tm_pass "both objects moved to their new names with their old IDs ($PASS)"
