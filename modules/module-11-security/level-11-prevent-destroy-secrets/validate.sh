#!/usr/bin/env bash
source "$TM_LIB"
WANT=$(tm_recall master)
[[ -n "$WANT" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_in_state random_password.box_master "the master passphrase is no longer in state"
tm_assert_in_state local_sensitive_file.deed_register "the deed register file is no longer in state"
tm_assert_config_has 'prevent_destroy[[:space:]]*=[[:space:]]*true' "no resource sets prevent_destroy = true"

# A destroy plan must be refused for BOTH objects; the validator never destroys anything.
terraform plan -destroy -input=false -no-color >"$TM_LAST_OUT" 2>&1
CODE=$?
OUT=$(cat "$TM_LAST_OUT")
[[ $CODE -ne 0 ]] || tm_fail "terraform plan -destroy succeeded — nothing stops a teammate from destroying the deed box"
# terraform reports only the first refusal, so also check each resource block individually
for addr in random_password.box_master local_sensitive_file.deed_register; do
  ADDR="$addr" python3 - <<'PY' || tm_fail "$addr has no lifecycle { prevent_destroy = true } of its own"
import glob, os, re, sys
rtype, rname = os.environ["ADDR"].split(".")
for path in glob.glob("*.tf"):
    text = re.sub(r"(?m)^\s*(#|//).*$", "", open(path).read())
    m = re.search(r'resource\s+"%s"\s+"%s"\s*\{(.*?)^\}' % (rtype, rname), text, re.S | re.M)
    if m and re.search(r"prevent_destroy\s*=\s*true", m.group(1)):
        sys.exit(0)
sys.exit(1)
PY
done

# protection must not break normal operation or touch the data
tm_assert_no_changes
NOW=$(tm_state_attr random_password.box_master result | python3 -c 'import hashlib,sys; print(hashlib.sha256(sys.stdin.buffer.read()).hexdigest())')
[[ "$NOW" == "$WANT" ]] || tm_fail "the master passphrase was regenerated — the register can no longer be opened"
tm_assert_file register/deed-box.key "register/deed-box.key was removed"
tm_pass "terraform refuses to plan a destroy of the passphrase and the key file"
