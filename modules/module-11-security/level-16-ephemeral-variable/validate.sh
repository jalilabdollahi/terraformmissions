#!/usr/bin/env bash
source "$TM_LIB"
SECRET="demo-not-a-real-secret-sailloft-6612"
export TF_VAR_gateway_token="$SECRET"

tm_assert_config_has 'ephemeral[[:space:]]*=[[:space:]]*true' "the token variable must be declared ephemeral = true"
tm_validate "the configuration does not validate"
tm_apply

R=receipts/publish.log
tm_assert_file "$R" "the publish script never ran (no receipts/publish.log)"
tm_assert_file_contains "$R" "loft: Fairwind Sail Loft" "the script no longer receives the loft name"
WANT=$(printf '%s' "$SECRET" | python3 -c 'import hashlib,sys; print(hashlib.sha256(sys.stdin.buffer.read()).hexdigest())')
tm_assert_file_contains "$R" "token_digest: $WANT" "the script did not receive the gateway token in GATEWAY_TOKEN"

# the point of the mission: the token must not be in state
STATE=$(terraform state pull 2>/dev/null)
[[ -n "$STATE" ]] || tm_fail "could not read the state"
if grep -qF -- "$SECRET" <<<"$STATE"; then tm_fail "the gateway token is stored in the state file"; fi
SHOWN=$(terraform show -json 2>/dev/null)
if grep -qF -- "$SECRET" <<<"$SHOWN"; then tm_fail "the gateway token appears in terraform show -json"; fi
if grep -qF -- "$SECRET" "$TM_LAST_OUT"; then tm_fail "the token was printed during apply"; fi

tm_assert_output published_loft "Fairwind Sail Loft"
tm_assert_no_changes
tm_pass "the token reached the publish script but is not in state"
