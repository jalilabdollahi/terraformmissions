#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "tls_cert_request" "sensor"' "tls_cert_request.sensor must stay"
tm_assert_config_has 'private_key_pem[[:space:]]*=[[:space:]]*tls_private_key\.sensor\.private_key_pem' "the CSR must be signed with tls_private_key.sensor.private_key_pem"
tm_apply
tm_assert_file pki/turbine-07.csr
[[ "$(tm_file_mode pki/turbine-07.key)" == "600" ]] || tm_fail "the private key file must stay mode 0600"
openssl req -in pki/turbine-07.csr -noout -verify >"$TM_TMP/v.txt" 2>&1 || tm_fail "pki/turbine-07.csr is not a valid CSR (signature does not verify)"
grep -qi 'Saltmarsh Offshore Wind' <(openssl req -in pki/turbine-07.csr -noout -subject) || tm_fail "CSR subject lacks the organisation"
CSR_PUB=$(openssl req -in pki/turbine-07.csr -noout -pubkey 2>/dev/null | tr -d ' \n')
KEY_PUB=$(tm_state_attr tls_private_key.sensor public_key_pem | tr -d ' \n')
[[ -n "$CSR_PUB" && "$CSR_PUB" == "$KEY_PUB" ]] || tm_fail "the public key inside the CSR is not the public half of tls_private_key.sensor"
tm_assert_no_changes
tm_pass "CSR is valid and carries the sensor key's public half"
