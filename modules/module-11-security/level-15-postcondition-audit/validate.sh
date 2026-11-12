#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_has 'postcondition[[:space:]]*\{' "enforce the policy with a postcondition"
tm_validate "the configuration does not validate"
tm_apply
tm_assert_file clubhouse/logbook-signing.key "the signing key file was not created"
[[ "$(tm_file_mode clubhouse/logbook-signing.key)" == "600" ]] || tm_fail "clubhouse/logbook-signing.key has mode $(tm_file_mode clubhouse/logbook-signing.key) by default; it must be 0600"
tm_assert_output audited_mode 600
tm_assert_no_changes

# Probe on a COPY of the workspace: a looser mode must make the postcondition fail the apply.
probe() {
  local mode="$1"
  rm -rf "$TM_TMP/probe"; mkdir -p "$TM_TMP/probe"
  cp -R "$WORKSPACE/." "$TM_TMP/probe/"
  rm -rf "$TM_TMP/probe/.tm"
  ( cd "$TM_TMP/probe" && terraform apply -auto-approve -input=false -no-color -var "key_mode=$mode" >"$TM_TMP/probe.out" 2>&1 )
}
for loose in 0644 0640 0660; do
  if probe "$loose"; then tm_fail "an apply with key_mode=$loose succeeded — the audit does not reject a key readable by others"; fi
  grep -q 'Resource postcondition failed' "$TM_TMP/probe.out" || { sed 's/^/   │ /' "$TM_TMP/probe.out"; tm_fail "key_mode=$loose failed, but not through a postcondition"; }
done
probe 0600 || { sed 's/^/   │ /' "$TM_TMP/probe.out"; tm_fail "a correct 0600 key was rejected by the audit"; }
tm_pass "the postcondition audits the real file mode and the default is 0600"
