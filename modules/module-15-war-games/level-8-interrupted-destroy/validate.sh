#!/usr/bin/env bash
source "$TM_LIB"

REG=$(tm_recall register_id)
[[ -n "$REG" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_lacks 'on_failure' "ignoring the unrig failure skips the handover instead of doing it"
tm_assert_config_lacks 'ignore_changes' "lifecycle tricks are not a teardown"
tm_assert_config_has 'exhibitor_register' "the exhibitor register must remain in the configuration"

tm_validate

tm_assert_no_file crates/manifest.lock "the stale crate-manifest lock is still in place"
left=$(ls signage 2>/dev/null | grep -c .)
[[ "$left" == "0" ]] || tm_fail "signage/ still holds $left file(s) of torn-down stands that Terraform no longer tracks"

for s in s1 s2 s3; do
  grep -q "bay returned stand=$s" crates/unrig.log 2>/dev/null \
    || tm_fail "the venue desk never got the bay for stand $s back (crates/unrig.log)"
done

left=$(tm_state_list | grep -c 'hall_b' )
[[ "$left" == "0" ]] || tm_fail "$left Hall B object(s) are still tracked in state"
tm_assert_in_state random_id.exhibitor_register
[[ "$(tm_state_attr random_id.exhibitor_register id)" == "$REG" ]] || tm_fail "the exhibitor register serial changed"

tm_assert_no_destroy
TM_MSG="plan is not clean after the teardown" tm_assert_no_changes
tm_assert_file_contains plan/floor-plan.txt "HR-$(printf '%s' "$REG" | python3 -c 'import sys,base64;print(base64.urlsafe_b64decode(sys.stdin.read()+"==").hex())')"
if grep -q 'hb-' plan/floor-plan.txt; then tm_fail "floor plan still lists Hall B stands"; fi
tm_pass "Hall B torn down through the real handover, register untouched, plan clean"
