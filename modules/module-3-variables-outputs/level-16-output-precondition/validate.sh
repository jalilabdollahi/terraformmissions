#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'precondition[[:space:]]*\{' "guard the published output with a precondition block"

tm_apply
tm_assert_output shop_label "Alpine Tomme, matured 75 days"
tm_assert_file_equals shop/label.txt "Alpine Tomme, matured 75 days
"

# A young wheel must be blocked, and the failure must come from the output's precondition.
if terraform plan -no-color -input=false -var affinage_days=28 >"$TM_LAST_OUT" 2>&1; then
  tm_fail "a 28-day wheel was accepted — nothing stops it from being published"
fi
grep -qi "output value precondition failed" "$TM_LAST_OUT" \
  || { tm_show_last; tm_fail "the plan failed, but not through a precondition on the output (look for 'Module output value precondition failed')"; }

# Exactly at the minimum is allowed, and the threshold variable must be honoured.
tm_plan_json -var affinage_days=60
[[ "$(jq -r '.planned_values.outputs.shop_label.value' "$TM_TMP/plan.json")" == "Alpine Tomme, matured 60 days" ]] \
  || tm_fail "a wheel at exactly the minimum (60 days) should still be published"
if terraform plan -no-color -input=false -var affinage_days=40 -var min_affinage_days=45 >"$TM_LAST_OUT" 2>&1; then
  tm_fail "the guard ignores min_affinage_days — raising the minimum to 45 should block a 40-day wheel"
fi
tm_pass "shop_label refuses to publish wheels younger than min_affinage_days"
