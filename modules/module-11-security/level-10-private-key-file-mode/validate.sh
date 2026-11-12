#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_lacks 'resource[[:space:]]+"local_file"[[:space:]]+"private_key"' "the private key must not be written by a plain local_file resource"
tm_validate "the configuration does not validate"
tm_apply
if grep -q 'PRIVATE KEY' "$TM_LAST_OUT"; then tm_fail "private key material was printed during apply"; fi

K=keys/milkround_ed25519
tm_assert_file "$K" "the private key file $K does not exist"
tm_assert_file_contains "$K" "BEGIN OPENSSH PRIVATE KEY" "$K does not hold the OpenSSH private key"
[[ "$(tm_file_mode "$K")" == "600" ]] || tm_fail "$K has mode $(tm_file_mode "$K"); a private key must be 0600"
[[ "$(tm_file_mode keys)" == "700" ]] || tm_fail "the keys/ directory has mode $(tm_file_mode keys); it must be 0700"

PUB=$(tm_output_raw public_key)
[[ "$PUB" == ssh-ed25519* ]] || tm_fail "output public_key must still return the ED25519 public key"
tm_assert_file keys/milkround_ed25519.pub "the public key file is gone"
tm_assert_file_contains keys/milkround_ed25519.pub "$PUB"

# ssh-keygen refuses a private key that others can read, so this proves the mode in practice
if command -v ssh-keygen >/dev/null 2>&1; then
  DERIVED=$(ssh-keygen -y -f "$K" 2>&1)
  [[ "$DERIVED" == "$PUB"* ]] || tm_fail "ssh-keygen cannot use $K: $DERIVED"
fi

tm_plan_code >/dev/null
if grep -q 'PRIVATE KEY' "$TM_LAST_OUT"; then tm_fail "private key material appears in plan output"; fi
tm_assert_no_changes
tm_pass "private key is 0600 in a 0700 directory and usable by ssh-keygen"
