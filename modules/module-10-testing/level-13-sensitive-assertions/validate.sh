#!/usr/bin/env bash
source "$TM_LIB"

T=tests/locks.tftest.hcl
tm_assert_file "$T" "tests/locks.tftest.hcl is missing"
tm_assert_config_has '^run[[:space:]]+"code_policy"' "run code_policy is missing"
tm_assert_config_has '^run[[:space:]]+"public_label"' "run public_label is missing"
tm_assert_config_has 'regex\(' "the numeric-only regex assertion has been removed"
tm_assert_config_lacks 'nonsensitive\([[:space:]]*output\.lock_code' "the test unmasks the lock code itself - assert on its shape instead"
tm_assert_config_lacks 'condition[[:space:]]*=[[:space:]]*true' "an assertion was replaced with a constant"
grep -qE '^[[:space:]]*sensitive[[:space:]]*=[[:space:]]*true' locks.tf || tm_fail "lock_code must remain a sensitive output"

tm_tf test -verbose
if [[ $? -ne 0 ]]; then
  grep -E '^[[:space:]]+run "|Error:|Warning:' "$TM_LAST_OUT" | sed 's/^/   | /'
  tm_fail "terraform test is still failing"
fi
grep -q '^Success! 2 passed, 0 failed' "$TM_LAST_OUT" || tm_fail "both runs must pass"
# the secret must not leak into test output
LEAK="$TM_TMP/leak"
rm -rf "$LEAK"; mkdir -p "$LEAK"; cp -R ./. "$LEAK"/
(cd "$LEAK" && terraform apply -auto-approve -no-color) >"$TM_TMP/leak.out" 2>&1
if grep -qE 'lock_code *= *[0-9]{8}' "$TM_TMP/leak.out"; then
  tm_fail "lock_code is no longer sensitive"
fi

probe() {
  local why="$1" old="$2" new="$3" d="$TM_TMP/probe-$1"
  rm -rf "$d"; mkdir -p "$d"; cp -R ./. "$d"/
  python3 - "$d/locks.tf" "$old" "$new" <<'PY'
import sys
p, a, b = sys.argv[1:4]
s = open(p).read()
t = s.replace(a, b)
open(p, "w").write(t)
sys.exit(0 if s != t else 3)
PY
  [[ $? -eq 0 ]] || return 0
  rm -f "$d/terraform.tfstate" "$d/terraform.tfstate.backup"
  (cd "$d" && terraform test -no-color) >"$TM_TMP/probe.out" 2>&1 && tm_fail "the suite passes although $why"
}
probe "the code policy gets too short" 'length  = 8' 'length  = 6'
probe "the code includes special characters" 'special = false' 'special = true'
probe "the label loses its prefix" '"Unit ${' '"${'
tm_pass "the code policy is tested by length and alphabet, never by its value"
