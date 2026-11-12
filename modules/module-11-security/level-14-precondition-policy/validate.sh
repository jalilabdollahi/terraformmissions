#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_has 'precondition[[:space:]]*\{' "enforce the policy with a precondition block on the manifest resource"
tm_assert_config_lacks 'validation[[:space:]]*\{' "this mission enforces the policy with a resource precondition, not a variable validation"
tm_validate "the configuration does not validate"

refuse() {
  local label="$1"; shift
  terraform plan -input=false -no-color "$@" >"$TM_LAST_OUT" 2>&1 </dev/null
  local code=$?
  if [[ $code -eq 0 || $code -eq 2 ]]; then tm_fail "policy hole: $label was accepted"; fi
  grep -q 'Resource precondition failed' "$TM_LAST_OUT" || { tm_show_last; tm_fail "$label failed, but not with a resource precondition error"; }
}

refuse "a shelf kept only 7 days"  -var 'shelves={vault={retention_days=7,public=false}}'
refuse "a shelf with 29 days"      -var 'shelves={vault={retention_days=29,public=false},ok={retention_days=90,public=false}}'
refuse "a public shelf"            -var 'shelves={vault={retention_days=400,public=true}}'

C=$(tm_plan_code -var 'shelves={vault={retention_days=30,public=false}}')
[[ "$C" == "0" || "$C" == "2" ]] || { tm_show_last; tm_fail "a shelf at exactly 30 days, private, must be allowed"; }

# the shop's own shelves must satisfy its own policy
tm_apply
tm_assert_output_jq shelf_names 'length == 4' "the four shop shelves must all still exist"
for s in intake watches ledger window; do
  f="shelves/$s.manifest"
  tm_assert_file "$f" "manifest for shelf $s is missing"
  grep -q '^public=false$' "$f" || tm_fail "shelf $s is still public"
  days=$(sed -n 's/^retention_days=//p' "$f")
  [[ "$days" -ge 30 ]] || tm_fail "shelf $s holds pledged items only $days days"
done
tm_assert_no_changes
tm_pass "the policy is enforced by a precondition and every real shelf complies"
