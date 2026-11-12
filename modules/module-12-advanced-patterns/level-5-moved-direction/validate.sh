#!/usr/bin/env bash
source "$TM_LIB"

FP=$(tm_recall fingerprint)
[[ -n "$FP" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "tls_private_key" "master_key"' "the key must keep its new name tls_private_key.master_key"

DIR=$(python3 - <<'PY'
import glob, re
text = "\n".join(open(f).read() for f in glob.glob("*.tf"))
text = re.sub(r"#.*", "", text)
for m in re.finditer(r"moved\s*\{([^}]*)\}", text):
    body = m.group(1)
    f = re.search(r"from\s*=\s*(\S+)", body); t = re.search(r"to\s*=\s*(\S+)", body)
    if f and t:
        print(f.group(1) + " -> " + t.group(1))
PY
)
grep -qx 'tls_private_key.master -> tls_private_key.master_key' <<<"$DIR" \
  || tm_fail "no moved block records the rename from the OLD address to the NEW one (found: ${DIR:-none})"

tm_init
TM_MSG="the plan would destroy the master key" tm_assert_no_destroy
tm_apply

tm_assert_in_state tls_private_key.master_key "tls_private_key.master_key is not in state"
tm_assert_not_in_state tls_private_key.master "the key is still tracked under its old address"
[[ "$(tm_state_attr tls_private_key.master_key public_key_fingerprint_sha256)" == "$FP" ]] \
  || tm_fail "the master key was regenerated, every lock keyed to the old one would now fail"
[[ "$(tm_state_attr local_file.key_register id)" == "$(tm_recall register_id)" ]] \
  || tm_fail "the register file was rewritten although the key did not change"
tm_assert_file_equals keyshop/key-register.txt "master key fingerprint: ${FP}"$'\n'
tm_assert_no_changes
tm_pass "the key kept its identity (${FP}) under its new name"
