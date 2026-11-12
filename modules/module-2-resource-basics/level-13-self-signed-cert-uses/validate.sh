#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "tls_self_signed_cert" "scoreboard"' "tls_self_signed_cert.scoreboard must stay"
tm_assert_config_has 'subject[[:space:]]*\{' "the subject must be a nested block"
tm_apply
tm_assert_file pki/scoreboard.pem
USES=$(terraform show -json 2>/dev/null | jq -r '.values.root_module.resources[] | select(.address=="tls_self_signed_cert.scoreboard") | .values.allowed_uses | sort | join(",")')
[[ "$USES" == "digital_signature,key_encipherment,server_auth" ]] || tm_fail "allowed_uses is '$USES', expected digital_signature, key_encipherment and server_auth"
[[ "$(tm_state_attr tls_self_signed_cert.scoreboard validity_period_hours)" == "72" ]] || tm_fail "the certificate must stay valid for 72 hours"
SUBJ=$(openssl x509 -in pki/scoreboard.pem -noout -subject 2>&1) || tm_fail "pki/scoreboard.pem is not a readable certificate"
grep -qi 'scoreboard.arena.lan' <<<"$SUBJ" || tm_fail "certificate subject has no CN scoreboard.arena.lan ($SUBJ)"
grep -qi 'Nightfall Arena' <<<"$SUBJ" || tm_fail "certificate subject has no organisation Nightfall Arena ($SUBJ)"
openssl x509 -in pki/scoreboard.pem -noout -text 2>/dev/null | grep -q 'TLS Web Server Authentication' || tm_fail "certificate is not marked for TLS server authentication"
tm_assert_output_jq cert_valid_until 'test("^20[0-9]{2}-")'
tm_assert_no_changes
tm_pass "scoreboard certificate has the right subject and usages"
