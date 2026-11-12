#!/usr/bin/env bash
source "$TM_LIB"

T=tests/dispatch.tftest.hcl
tm_assert_file "$T" "tests/dispatch.tftest.hcl is missing"
tm_assert_config_has '^mock_provider[[:space:]]+"random"' "the random provider must stay mocked"
tm_assert_config_has 'mock_resource[[:space:]]+"random_id"' "random_id is no longer mocked"
tm_assert_config_has 'mock_resource[[:space:]]+"random_integer"' "random_integer is no longer mocked"
tm_assert_config_has 'WC-AB12CD34' "the ticket assertion must expect WC-AB12CD34"
tm_assert_config_has 'zone-4' "the zone assertion must expect zone-4"
n=$(grep -cE '^run[[:space:]]+"' "$T")
[[ "$n" -eq 3 ]] || tm_fail "expected the three original runs, found $n"

tm_validate "the configuration itself should still validate"

tm_tf test -verbose
code=$?
if [[ $code -ne 0 ]]; then
  tm_show_last
  tm_fail "terraform test is failing"
fi
grep -q '^Success! 3 passed, 0 failed' "$TM_LAST_OUT" || tm_fail "all three runs must pass"

# the assertions must really depend on the code's formatting
bug() {
  local label="$1" old="$2" new="$3" d="$TM_TMP/bug-$1"
  rm -rf "$d"; mkdir -p "$d"; cp -R ./. "$d"/
  python3 - "$d/dispatch.tf" "$old" "$new" <<'PY'
import sys
p, a, b = sys.argv[1:4]
s = open(p).read()
t = s.replace(a, b)
open(p, "w").write(t)
sys.exit(0 if s != t else 3)
PY
  [[ $? -eq 0 ]] || return 0
  if (cd "$d" && terraform test -no-color) >"$TM_TMP/bug.out" 2>&1; then
    tm_fail "the suite passes although the code has this bug: $label"
  fi
}
bug "ticket prefix changed" '"WC-${' '"WX-${'
bug "ticket not upper-cased" 'upper(random_id.ticket.hex)' 'random_id.ticket.hex'
bug "zone label changed" '"zone-${' '"z-${'
tm_pass "the mock pins both random values and the format assertions bite"
