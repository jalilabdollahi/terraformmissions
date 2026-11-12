#!/usr/bin/env bash
source "$TM_LIB"

LOT=$(tm_recall heat_lot_id)
[[ -n "$LOT" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_lacks 'ignore_changes' "ignore_changes hides drift; it does not reconcile it"
tm_assert_config_lacks '"mold_c"' "mold C was scrapped - nothing should still manage it"
tm_assert_config_has '1450' "the approved pour temperature is not in the code"
tm_assert_config_lacks '1380' "the superseded pour temperature is still in the code"
tm_assert_config_has 'resource "local_file" "furnace_b"' "furnace B's control file must stay managed"

CUR=$(tm_state_attr random_id.heat_lot id)
[[ -n "$CUR" ]] || tm_fail "the heat lot is not in state"
[[ "$CUR" == "$LOT" ]] || tm_fail "the campaign heat lot was regenerated — stamps that already shipped no longer match"

tm_assert_not_in_state local_file.mold_c "mold C is still tracked in state"
tm_assert_no_destroy
TM_MSG="plan is not clean — some drifted object is still unreconciled" tm_assert_no_changes

tm_assert_file_contains furnaces/furnace-a.cfg "quench_seconds = 40" "furnace A still has the fat-fingered quench time"
tm_assert_file furnaces/furnace-b.cfg "furnace B's control file is missing on disk"
tm_assert_file_contains furnaces/furnace-b.cfg "HL-$(printf '%s' "$LOT" | python3 -c 'import sys,base64;print(base64.urlsafe_b64decode(sys.stdin.read()+"==").hex())')" "furnace B file carries the wrong heat lot"
tm_assert_file_contains recipes/bronze-pour.cfg "pour_temp_c   = 1450" "the bronze recipe lost the approved 1450 C pour"
tm_assert_no_file molds/mold-c.cfg
tm_pass "all five drifts reconciled the right way; heat lot HL-${LOT} untouched"
