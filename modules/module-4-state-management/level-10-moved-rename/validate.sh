#!/usr/bin/env bash
source "$TM_LIB"

PASS=$(tm_recall pass_id); SIGN=$(tm_recall sign_id)
[[ -n "$PASS" && -n "$SIGN" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "random_id" "climb_pass"' "the resource must keep its new name random_id.climb_pass"
tm_assert_config_has 'resource "local_file" "harness_sign"' "the resource must keep its new name local_file.harness_sign"
tm_assert_config_lacks 'resource[[:space:]]+"random_id"[[:space:]]+"zip_pass"' "the old name random_id.zip_pass came back"
tm_assert_config_lacks 'resource[[:space:]]+"local_file"[[:space:]]+"gate_sign"' "the old name local_file.gate_sign came back"

tm_assert_config_has 'from[[:space:]]*=[[:space:]]*random_id\.zip_pass' "no moved block starts from random_id.zip_pass"
tm_assert_config_has 'to[[:space:]]*=[[:space:]]*random_id\.climb_pass' "no moved block points to random_id.climb_pass"
tm_assert_config_has 'from[[:space:]]*=[[:space:]]*local_file\.gate_sign' "no moved block starts from local_file.gate_sign"
tm_assert_config_has 'to[[:space:]]*=[[:space:]]*local_file\.harness_sign' "no moved block points to local_file.harness_sign"

tm_assert_not_in_state random_id.zip_pass "the old address random_id.zip_pass is still in state — a moved block takes effect on apply"
tm_assert_not_in_state local_file.gate_sign "the old address local_file.gate_sign is still in state — apply the moves"
tm_assert_in_state random_id.climb_pass "random_id.climb_pass is not in state yet"
tm_assert_in_state local_file.harness_sign "local_file.harness_sign is not in state yet"

[[ "$(tm_state_attr random_id.climb_pass id)" == "$PASS" ]] || tm_fail "the climb-pass code changed — the sold harness tags are void"
[[ "$(tm_state_attr local_file.harness_sign id)" == "$SIGN" ]] || tm_fail "the harness sign was recreated"

tm_assert_no_changes
tm_pass "both objects moved to their new names with their old IDs ($PASS)"
