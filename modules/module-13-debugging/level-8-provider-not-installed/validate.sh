#!/usr/bin/env bash
source "$TM_LIB"

BOAT=$(tm_recall boat)
[[ -n "$BOAT" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"

ANS=answers/missing.txt
tm_assert_file "$ANS" "answers/missing.txt does not exist - record which provider Terraform complained about"
LINE=$(head -n1 "$ANS" | tr -d '[:space:]')
[[ "$LINE" == "missing_provider=registry.terraform.io/hashicorp/tls" ]] \
  || tm_fail "answers/missing.txt must contain missing_provider=<full source address of the missing provider>, found '$LINE'"

tm_assert_config_has 'hashicorp/tls' "the tls provider requirement must stay in the configuration"
tm_assert_config_has 'tls_private_key' "the signing key resource must stay"
[[ -f .terraform.lock.hcl ]] && grep -q 'registry.terraform.io/hashicorp/tls' .terraform.lock.hcl \
  || tm_fail "the dependency lock file has no entry for the tls provider - the directory was never initialised for it"

tm_apply
tm_assert_no_changes
tm_assert_no_changes

tm_assert_in_state tls_private_key.logbook_signer "the signing key is not in state"
tm_assert_output boat_name "$BOAT"
FP=$(tm_output_raw signing_fingerprint)
[[ "$FP" == SHA256:* ]] || tm_fail "signing_fingerprint output looks wrong: '$FP'"
tm_assert_file_contains divelog/signature.txt "$FP" "divelog/signature.txt does not show the signing fingerprint"
tm_assert_file_contains divelog/logbook.txt "$BOAT" "the boat logbook changed"
tm_pass "the tls provider is installed, the key exists and boat '$BOAT' is untouched"
