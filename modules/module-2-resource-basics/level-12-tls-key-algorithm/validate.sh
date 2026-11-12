#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "tls_private_key" "telemetry"' "tls_private_key.telemetry must stay"
tm_assert_config_has 'resource "tls_private_key" "firmware"' "tls_private_key.firmware must stay"
tm_apply
[[ "$(tm_state_attr tls_private_key.telemetry algorithm)" == "ECDSA" ]] || tm_fail "telemetry key must use the ECDSA algorithm"
[[ "$(tm_state_attr tls_private_key.telemetry ecdsa_curve)" == "P256" ]] || tm_fail "telemetry key must use curve P256"
[[ "$(tm_state_attr tls_private_key.firmware algorithm)" == "RSA" ]] || tm_fail "firmware key must stay RSA"
[[ "$(tm_state_attr tls_private_key.firmware rsa_bits)" == "4096" ]] || tm_fail "firmware key must be 4096 bits"
tm_assert_file fleet-keys/telemetry.pub
tm_assert_file fleet-keys/firmware.pub
head -c 20 fleet-keys/telemetry.pub | grep -q '^ecdsa-sha2-nistp256 ' || tm_fail "telemetry.pub is not an ecdsa-sha2-nistp256 OpenSSH public key"
head -c 8 fleet-keys/firmware.pub | grep -q '^ssh-rsa ' || tm_fail "firmware.pub is not an ssh-rsa OpenSSH public key"
tm_assert_output telemetry_algorithm ECDSA
tm_assert_no_changes
tm_pass "ECDSA P256 telemetry key and RSA-4096 firmware key published"
