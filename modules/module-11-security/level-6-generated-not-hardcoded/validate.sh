#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_lacks 'demo-not-a-real-secret-lookout' "the old passphrase is still written in the configuration"
tm_assert_config_has 'resource[[:space:]]+"random_password"[[:space:]]+"radio_admin"' "generate the passphrase with random_password.radio_admin"

tm_validate "the configuration does not validate"
tm_apply
tm_assert_in_state random_password.radio_admin "random_password.radio_admin is not in state"

PW=$(tm_state_attr random_password.radio_admin result)
[[ ${#PW} -ge 24 ]] || tm_fail "the generated passphrase is only ${#PW} characters — the policy is at least 24"
[[ "$PW" =~ [a-z].*[a-z] && "$PW" =~ [A-Z].*[A-Z] && "$PW" =~ [0-9].*[0-9] ]] \
  || tm_fail "the passphrase must contain at least two lower-case, two upper-case and two numeric characters"

tm_assert_file radio/admin.conf "radio/admin.conf was not written"
tm_assert_file_contains radio/admin.conf "admin_passphrase=$PW" "radio/admin.conf must carry the generated passphrase from state"
tm_assert_file_contains radio/admin.conf "tower=Pine Ridge Lookout"
[[ "$(tm_file_mode radio/admin.conf)" == "600" ]] || tm_fail "radio/admin.conf must be mode 0600"
if grep -qF -- "$PW" "$TM_LAST_OUT"; then tm_fail "the generated passphrase appeared in apply output"; fi

# stable: a second plan must not rotate the passphrase
tm_assert_no_changes
[[ "$(tm_state_attr random_password.radio_admin result)" == "$PW" ]] || tm_fail "the passphrase changed between runs"
tm_pass "the lookout passphrase is generated, 24+ characters, and kept out of the source"
