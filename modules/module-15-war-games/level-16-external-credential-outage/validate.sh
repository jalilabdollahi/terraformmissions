#!/usr/bin/env bash
source "$TM_LIB"

[[ -n "$(tm_recall vessel_key)" && -n "$(tm_recall bin_sum)" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"

[[ "$(cat bin/qr_auth.py bin/quota_lookup.py bin/stamp.py 2>/dev/null | shasum | cut -d' ' -f1)" == "$(tm_recall bin_sum)" ]] \
  || tm_fail "the registry tooling in bin/ was modified - it is owned by another team; fix the pipeline's inputs instead"
tm_assert_config_has 'data[[:space:]]+"external"[[:space:]]+"quota"' "the quota must still come from the registry lookup"
tm_assert_config_lacks 'qr1\.' "a registry token is written into the Terraform code"
tm_assert_config_lacks 'tonnes[[:space:]]*=[[:space:]]*"?[0-9]+' "the quota must not be hard-coded"
tm_assert_file .credentials/quota-token "the credential file is missing"
[[ "$(tm_file_mode .credentials/quota-token)" == "600" ]] || tm_fail ".credentials/quota-token must be mode 600 as the rotation ticket requires (is $(tm_file_mode .credentials/quota-token))"
if grep -rq 'qr1\.' --include='*.tfvars' --include='*.tf' --exclude-dir=.terraform . 2>/dev/null; then tm_fail "token found in Terraform files"; fi

STATE_JSON=$(terraform state pull 2>/dev/null)
[[ -n "$STATE_JSON" ]] || tm_fail "cannot read state"
STATUS=$(jq -r '.resources[] | select(.type=="terraform_data" and .name=="permit_stamp") | .instances[0].status // "ok"' <<<"$STATE_JSON")
[[ "$STATUS" != "tainted" ]] || tm_fail "terraform_data.permit_stamp is still tainted - the half-finished stamp was never redone"

TM_MSG="plan would replace the vessel key" tm_assert_no_destroy
tm_assert_no_changes
[[ "$(tm_state_attr random_id.vessel_key hex)" == "$(tm_recall vessel_key)" ]] || tm_fail "the vessel key was re-issued during recovery"
[[ "$(tm_state_attr terraform_data.permit_stamp id)" != "$(tm_recall stamp_id)" ]] || tm_fail "the stamp was never re-run: the object is the one from the failed night"
tm_assert_file_equals out/permit-stamp.txt "STAMPED vessel BRK-114 Marguerite key $(tm_recall vessel_key) tonnes $(tm_recall tonnes)"$'\n' "out/permit-stamp.txt is not a completed stamp for this vessel"
tm_assert_output quota_tonnes "$(tm_recall tonnes)"
tm_assert_file_contains logs/quota-lookup.log "stamp ok region=north-sea" "the registry never recorded a successful stamp"
tm_pass "credential restored with mode 600, region corrected, tainted stamp redone, vessel key untouched"
