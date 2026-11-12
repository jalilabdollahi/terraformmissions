#!/usr/bin/env bash
source "$TM_LIB"

REG=$(tm_recall register_id)
[[ -n "$REG" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_lacks 'on_failure' "ignoring the unrig failure skips the handover instead of doing it"
tm_assert_config_lacks 'ignore_changes' "lifecycle tricks are not a teardown"
tm_assert_config_has 'client_register' "the client register must remain in the configuration"

tm_validate

tm_assert_no_file crates/manifest.lock "the stale crate-manifest lock is still in place"
left=$(ls tags 2>/dev/null | grep -c .)
[[ "$left" == "0" ]] || tm_fail "tags/ still holds $left file(s) of torn-down marquees that Terraform no longer tracks"

for s in m1 m2 m3; do
  grep -q "rig returned marquee=$s" crates/unrig.log 2>/dev/null \
    || tm_fail "the site desk never got the rig for marquee $s back (crates/unrig.log)"
done

left=$(tm_state_list | grep -c 'field_b' )
[[ "$left" == "0" ]] || tm_fail "$left Field B object(s) are still tracked in state"
tm_assert_in_state random_id.client_register
[[ "$(tm_state_attr random_id.client_register id)" == "$REG" ]] || tm_fail "the client register serial changed"

tm_assert_no_destroy
TM_MSG="plan is not clean after the teardown" tm_assert_no_changes
tm_assert_file_contains plan/site-plan.txt "HR-$(printf '%s' "$REG" | python3 -c 'import sys,base64;print(base64.urlsafe_b64decode(sys.stdin.read()+"==").hex())')"
if grep -q 'hb-' plan/site-plan.txt; then tm_fail "site plan still lists Field B marquees"; fi
tm_pass "Field B torn down through the real handover, register untouched, plan clean"
