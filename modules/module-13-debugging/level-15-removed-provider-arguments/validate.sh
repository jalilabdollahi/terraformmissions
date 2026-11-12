#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'version[[:space:]]*=[[:space:]]*"~>[[:space:]]*4' "the tls provider constraint must stay on the 4.x line"
tm_assert_config_lacks '^[[:space:]]*(ca_)?key_algorithm[[:space:]]*=' "key_algorithm is no longer an argument of these resources"
tm_assert_config_has 'tls_cert_request' "the certificate request must stay"
tm_assert_config_has 'tls_self_signed_cert' "the self-signed certificate must stay"

[[ -f .terraform.lock.hcl ]] || tm_fail "no lock file - is terraform init working?"
LOCKED=$(awk '/provider "registry.terraform.io\/hashicorp\/tls"/{f=1} f && /^[[:space:]]*version/{gsub(/[" ]/,"",$3); print $3; exit}' .terraform.lock.hcl)
[[ "${LOCKED%%.*}" == "4" ]] || tm_fail "tls is locked at '$LOCKED' - the mission is to move to the 4.x provider"

tm_apply
tm_assert_no_changes
tm_assert_no_changes

tm_assert_output spillway_key_algorithm "ECDSA"
[[ "$(tm_state_attr tls_self_signed_cert.spillway validity_period_hours)" == "720" ]] \
  || tm_fail "the self-signed certificate must be valid for 720 hours"
tm_assert_file_contains spillway/spillway-4.crt "BEGIN CERTIFICATE" "spillway/spillway-4.crt is not a certificate"
tm_assert_file_contains spillway/spillway-4.csr "BEGIN CERTIFICATE REQUEST" "spillway/spillway-4.csr is not a certificate request"
if command -v openssl >/dev/null 2>&1; then
  SUBJ=$(openssl x509 -noout -subject -in spillway/spillway-4.crt 2>/dev/null)
  case "$SUBJ" in
    *spillway-4.ironvale-dam.example*) ;;
    *) tm_fail "the certificate subject is wrong: $SUBJ" ;;
  esac
fi
[[ "$(tm_state_attr tls_self_signed_cert.spillway key_algorithm)" == "ECDSA" ]] \
  || tm_fail "the certificate should still be derived from the ECDSA key"
tm_pass "spillway-4's certificate and request are issued with the 4.x provider ($LOCKED)"
