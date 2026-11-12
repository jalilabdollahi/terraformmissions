#!/usr/bin/env bash
source "$TM_LIB"

LOT=$(tm_recall cocoa_lot_id)
[[ -n "$LOT" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_lacks 'ignore_changes' "ignore_changes hides drift; it does not reconcile it"
tm_assert_config_lacks '"mold_c"' "mold C was scrapped - nothing should still manage it"
tm_assert_config_has '122' "the approved melt temperature is not in the code"
tm_assert_config_lacks '118' "the superseded melt temperature is still in the code"
tm_assert_config_has 'resource "local_file" "kettle_b"' "kettle B's control file must stay managed"

CUR=$(tm_state_attr random_id.cocoa_lot id)
[[ -n "$CUR" ]] || tm_fail "the cocoa lot is not in state"
[[ "$CUR" == "$LOT" ]] || tm_fail "the campaign cocoa lot was regenerated — wrappers that already shipped no longer match"

tm_assert_not_in_state local_file.mold_c "mold C is still tracked in state"
tm_assert_no_destroy
TM_MSG="plan is not clean — some drifted object is still unreconciled" tm_assert_no_changes

tm_assert_file_contains kettles/kettle-a.cfg "chill_seconds = 40" "kettle A still has the fat-fingered chill time"
tm_assert_file kettles/kettle-b.cfg "kettle B's control file is missing on disk"
tm_assert_file_contains kettles/kettle-b.cfg "CL-$(printf '%s' "$LOT" | python3 -c 'import sys,base64;print(base64.urlsafe_b64decode(sys.stdin.read()+"==").hex())')" "kettle B file carries the wrong cocoa lot"
tm_assert_file_contains recipes/dark-temper.cfg "melt_temp_f   = 122" "the dark-chocolate recipe lost the approved 122 F melt"
tm_assert_no_file molds/mold-c.cfg
tm_pass "all five drifts reconciled the right way; cocoa lot CL-${LOT} untouched"
