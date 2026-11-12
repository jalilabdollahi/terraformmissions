#!/usr/bin/env bash
source "$TM_LIB"

CA_KEY=$(tm_recall ca_key_id); SC_KEY=$(tm_recall sorter_key_id); CA_FP=$(tm_recall ca_pub)
[[ -n "$CA_KEY" && -n "$SC_KEY" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

# Rolling back to 3.x is not an upgrade.
tm_assert_config_lacks '3\.4\.0' "the tls provider must move forward, not stay pinned at 3.4.0"
tm_assert_config_lacks '^[[:space:]]*(ca_)?key_algorithm[[:space:]]*=' "removed provider arguments are still in the configuration"
LOCK=$(cat .terraform.lock.hcl 2>/dev/null)
tls_ver=$(printf '%s\n' "$LOCK" | awk '/hashicorp\/tls"/{f=1} f&&/version/{print $3; exit}' | tr -d '"')
[[ "$tls_ver" == 4.* ]] || tm_fail "the lock file still selects tls '$tls_ver' — the working directory has not been upgraded to the 4.x provider"
local_ver=$(printf '%s\n' "$LOCK" | awk '/hashicorp\/local"/{f=1} f&&/version/{print $3; exit}' | tr -d '"')
[[ "$local_ver" != 2.4.* ]] || tm_fail "the lock file still selects the old local provider ($local_ver)"

tm_validate "configuration does not validate against the installed providers"

[[ "$(tm_state_attr tls_private_key.ca id)" == "$CA_KEY" ]] \
  || tm_fail "the CA private key was replaced — every sorter on the line pins the old CA key"
[[ "$(tm_state_attr tls_private_key.sorter id)" == "$SC_KEY" ]] \
  || tm_fail "the sorter private key was replaced"
[[ "$(tm_state_attr tls_private_key.ca public_key_fingerprint_sha256)" == "$CA_FP" ]] \
  || tm_fail "the CA public key fingerprint changed"

TM_MSG="plan is not clean after the upgrade" tm_assert_no_changes
tm_assert_no_destroy

tm_assert_file pki/ca.pem; tm_assert_file pki/sorter.pem; tm_assert_file pki/sorter.key
[[ "$(tm_file_mode pki/sorter.key)" == "600" ]] || tm_fail "pki/sorter.key must stay mode 0600"
if ! openssl verify -CAfile pki/ca.pem pki/sorter.pem >"$TM_TMP/ossl.txt" 2>&1; then
  sed 's/^/   │ /' "$TM_TMP/ossl.txt"
  tm_fail "the sorter certificate on disk does not verify against pki/ca.pem"
fi
subj=$(openssl x509 -in pki/sorter.pem -noout -subject 2>/dev/null)
grep -q 'belt-sorter-07' <<<"$subj" || tm_fail "sorter certificate has the wrong subject: $subj"
tm_pass "tls 4.x installed, keys preserved, certificate chain verifies, plan clean"
