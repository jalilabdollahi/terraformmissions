#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'ephemeral[[:space:]]+"tls_private_key"[[:space:]]+"scooter"' "the key has to stay an ephemeral resource"
tm_assert_config_has 'private_key_pem_wo[[:space:]]*=[[:space:]]*ephemeral\.tls_private_key\.scooter\.private_key_pem' \
  "feed the ephemeral key to the write-only argument of the request"
tm_assert_config_lacks 'resource[[:space:]]+"tls_private_key"' "do not turn the key back into a persisted resource"

tm_validate "the configuration does not validate"
tm_apply

tm_assert_in_state tls_cert_request.scooter
tm_assert_in_state local_file.csr
tm_assert_file_contains pki/scooter-07.csr "BEGIN CERTIFICATE REQUEST" "the request file is not a PEM certificate request"

# The private key must be nowhere in persisted state.
STATE=$(terraform state pull 2>/dev/null)
grep -q 'PRIVATE KEY' <<<"$STATE" && tm_fail "a private key was written to the state file"

tm_assert_no_changes
tm_pass "the CSR was signed with an ephemeral key that never reached the state"
