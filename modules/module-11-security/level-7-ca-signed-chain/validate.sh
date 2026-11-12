#!/usr/bin/env bash
source "$TM_LIB"
tm_validate "the configuration does not validate"
tm_apply
R=pki/root-ca.pem
S=pki/signals.pem
tm_assert_file "$R" "pki/root-ca.pem was not written"
tm_assert_file "$S" "pki/signals.pem was not written"

TXT=$(openssl x509 -in "$R" -noout -text 2>&1)
[[ "$TXT" == *"CA:TRUE"* ]] || tm_fail "the root certificate is not marked as a CA (basicConstraints CA:TRUE missing)"
[[ "$TXT" == *"Certificate Sign"* ]] || tm_fail "the root certificate cannot sign certificates (keyUsage lacks Certificate Sign)"

SUBJ=$(openssl x509 -in "$S" -noout -subject 2>&1)
ISS=$(openssl x509 -in "$S" -noout -issuer 2>&1)
[[ "$SUBJ" == *"signals.cinderloop.test"* ]] || tm_fail "pki/signals.pem is not the signals controller certificate: $SUBJ"
[[ "$ISS" == *"Cinder Loop Depot Root CA"* ]] || tm_fail "the controller certificate was not issued by the depot root CA (issuer: $ISS)"

V=$(openssl verify -CAfile "$R" "$S" 2>&1)
[[ "$V" == *": OK"* ]] || { echo "   │ $V"; tm_fail "openssl cannot verify pki/signals.pem against pki/root-ca.pem"; }

# the controller certificate must not itself be able to sign other certificates
STXT=$(openssl x509 -in "$S" -noout -text 2>&1)
[[ "$STXT" != *"CA:TRUE"* ]] || tm_fail "the leaf certificate is marked CA:TRUE — it must be an end-entity certificate"
[[ "$STXT" == *"signals.cinderloop.test"* && "$STXT" == *"DNS:"* ]] || tm_fail "the leaf certificate lost its DNS name"
tm_assert_no_changes
tm_pass "signals.pem verifies against the depot root CA"
