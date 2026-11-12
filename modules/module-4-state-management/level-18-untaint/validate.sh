#!/usr/bin/env bash
source "$TM_LIB"

FP=$(tm_recall fingerprint); PUB=$(tm_recall pub_id)
[[ -n "$FP" && -n "$PUB" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "tls_private_key" "firmware_signer"' "the signing key resource was removed from the configuration"
tm_assert_in_state tls_private_key.firmware_signer "the signing key is not in state"

NOW=$(tm_state_attr tls_private_key.firmware_signer public_key_fingerprint_sha256)
[[ "$NOW" == "$FP" ]] || tm_fail "the signing key was regenerated — fingerprint is now $NOW; the devices trust $FP"
[[ "$(tm_state_attr local_file.bootloader_pubkey id)" == "$PUB" ]] || tm_fail "the bootloader public key file was rewritten"

# A tainted resource shows up in the state JSON as "tainted"; the plan would replace it.
tm_assert_no_destroy
tm_assert_no_changes
tm_pass "the signing key is no longer tainted and keeps fingerprint $FP"
