#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "local_file" "chiller"' "the chiller resource must stay in the config"
tm_assert_file ops/plan.sh "ops/plan.sh is missing"
tm_assert_in_state 'local_file.chiller["yoghurt-b"]' "mission state is missing — run 'reset' to restore the level"
[[ ! -e chiller/yoghurt-b.txt ]] \
  || tm_fail "chiller/yoghurt-b.txt exists again — this mission wants the drift to stay in place so the audit can find it (run 'reset' if you applied)"

# quick: must stay fast = must not read reality, so it is blind to the drift and exits 0.
bash ops/plan.sh quick >"$TM_TMP/quick.out" 2>&1
quick_code=$?
if [[ "$quick_code" != "0" ]]; then
  cat "$TM_TMP/quick.out" | head -15 | sed 's/^/   │ /'
  tm_fail "ops/plan.sh quick exited $quick_code with the drift still present — the fast loop should trust state (-refresh=false) and report nothing"
fi

# audit: must read reality and exit 2 naming the missing chiller.
bash ops/plan.sh audit >"$TM_TMP/audit.out" 2>&1
audit_code=$?
if [[ "$audit_code" != "2" ]]; then
  tm_fail "ops/plan.sh audit exited $audit_code — the nightly check has to notice the deleted setpoint file (expected exit 2)"
fi
grep -q 'yoghurt-b' "$TM_TMP/audit.out" \
  || tm_fail "the audit output does not mention yoghurt-b"

# other modes keep failing.
bash ops/plan.sh bogus >/dev/null 2>&1
[[ $? != 0 ]] || tm_fail "ops/plan.sh must reject unknown modes with a non-zero exit"

# The audit must not have changed anything.
[[ ! -e chiller/yoghurt-b.txt ]] || tm_fail "the audit script must only plan, never apply"
tm_pass "quick stays blind and fast; audit exits 2 and reports yoghurt-b missing"
