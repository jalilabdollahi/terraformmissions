#!/usr/bin/env bash
source "$TM_LIB"
OLD=$(tm_recall serial)
[[ -n "$OLD" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_validate "the configuration does not validate"
tm_apply

C=pki/pump.pem
tm_assert_file "$C" "pki/pump.pem is missing"
NEW=$(openssl x509 -in "$C" -noout -serial)
[[ "$NEW" != "$OLD" ]] || tm_fail "the pump controller still has the original certificate (serial $NEW) — it has not been rotated"

if ! openssl x509 -in "$C" -noout -checkend 5184000 >/dev/null 2>&1; then
  tm_fail "the certificate expires within 60 days — the dock wants at least 60 days of validity"
fi
tm_info "$(openssl x509 -in "$C" -noout -enddate)"

EARLY=$(tm_state_attr tls_self_signed_cert.pump early_renewal_hours)
VALID=$(tm_state_attr tls_self_signed_cert.pump validity_period_hours)
[[ -n "$EARLY" && "$EARLY" -ge 168 ]] || tm_fail "early_renewal_hours is ${EARLY:-unset}; Terraform should start rotating at least 7 days (168 h) before expiry"
[[ "$EARLY" -lt "$VALID" ]] || tm_fail "early_renewal_hours ($EARLY) must be smaller than validity_period_hours ($VALID), or the cert is renewed on every plan"

[[ "$(tm_file_mode pki/pump.key)" == "600" ]] || tm_fail "pki/pump.key must stay mode 0600"
tm_assert_no_changes
tm_pass "the pump certificate was rotated and has a renewal window of ${EARLY}h before expiry"
