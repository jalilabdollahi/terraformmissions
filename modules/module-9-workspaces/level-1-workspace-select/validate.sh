#!/usr/bin/env bash
source "$TM_LIB"

CURRENT=$(terraform workspace show 2>/dev/null)
[[ "$CURRENT" == "staging" ]] || tm_fail "the selected workspace is '$CURRENT' — the grooming plan belongs to the staging environment"

tm_assert_config_has 'terraform\.workspace' "the plan file must still be named from terraform.workspace"
tm_assert_config_lacks 'staging' "do not hard-code the workspace name in the configuration"

STAGING_STATE=terraform.tfstate.d/staging/terraform.tfstate
[[ -s "$STAGING_STATE" ]] || tm_fail "the staging workspace has no state yet — nothing has been applied there"
TRACKED=$(jq -r '[.resources[]? | select(.type == "local_file") | .instances[].attributes.filename] | join(",")' "$STAGING_STATE")
[[ "$TRACKED" == *"out/staging-groomer-plan.txt" ]] \
  || tm_fail "staging's state does not track out/staging-groomer-plan.txt (it tracks: '${TRACKED:-nothing}')"
tm_assert_file_contains out/staging-groomer-plan.txt "Grooming plan for staging" "the staging plan file has the wrong content"

PROD_STATE=terraform.tfstate.d/prod/terraform.tfstate
if [[ -s "$PROD_STATE" ]]; then
  PROD_COUNT=$(jq '[.resources[]?] | length' "$PROD_STATE")
  [[ "$PROD_COUNT" == "0" ]] || tm_fail "the prod workspace now holds resources — only staging should have been touched"
fi
[[ ! -e out/prod-groomer-plan.txt ]] || tm_fail "out/prod-groomer-plan.txt exists — prod must stay untouched"

tm_assert_no_changes
tm_pass "staging is selected, its own state tracks out/staging-groomer-plan.txt, prod is untouched and the plan is clean"
