#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_has 'ephemeral[[:space:]]+"random_password"' "the token must come from an ephemeral random_password resource"
tm_assert_config_has 'ephemeral[[:space:]]*=[[:space:]]*true' "the module output carrying the token must be declared ephemeral = true"
tm_assert_config_lacks 'resource[[:space:]]+"random_password"' "a regular random_password resource stores the token in state"
tm_validate "the configuration does not validate"
tm_apply

T=handoff/session.token
tm_assert_file "$T" "the hand-off never ran: handoff/session.token is missing"
TOKEN=$(cat "$T")
[[ ${#TOKEN} -ge 32 ]] || tm_fail "the dispatch box holds a token of only ${#TOKEN} characters"
tm_assert_file_contains handoff/receipt.txt "taxi: station-to-airport"
tm_assert_file_contains handoff/receipt.txt "token_length: ${#TOKEN}"

STATE=$(terraform state pull 2>/dev/null)
[[ -n "$STATE" ]] || tm_fail "could not read the state"
if grep -qF -- "$TOKEN" <<<"$STATE"; then tm_fail "the session token is stored in the state file"; fi
SHOWN=$(terraform show -json 2>/dev/null)
if grep -qF -- "$TOKEN" <<<"$SHOWN"; then tm_fail "the session token appears in terraform show -json"; fi
if grep -qF -- "$TOKEN" "$TM_LAST_OUT"; then tm_fail "the token was printed during apply"; fi
tm_assert_output route station-to-airport
tm_assert_no_changes
tm_pass "the token travelled from the child module to the dispatch hand-off without touching state"
