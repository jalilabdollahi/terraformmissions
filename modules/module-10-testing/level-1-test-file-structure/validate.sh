#!/usr/bin/env bash
source "$TM_LIB"

for scenario in single_axle three_axles discount_half; do
  tm_assert_config_has "^[[:space:]]*run[[:space:]]+\"$scenario\"" \
    "scenario run \"$scenario\" is missing from tests/fares.tftest.hcl"
done
tm_assert_config_lacks '^[[:space:]]*test[[:space:]]+"' \
  "a block of type test still carries a label"
asserts=$(grep -c '^[[:space:]]*assert[[:space:]]*{' tests/fares.tftest.hcl 2>/dev/null)
[[ "${asserts:-0}" -ge 3 ]] || tm_fail "each scenario needs its assert block (found ${asserts:-0})"

if ! tm_tf test; then
  tm_show_last
  tm_fail "terraform test does not pass yet"
fi
summary=$(grep -E '^(Success|Failure)!' "$TM_LAST_OUT")
[[ "$summary" == "Success! 3 passed, 0 failed." ]] \
  || tm_fail "expected exactly 3 passing runs, terraform test said: $summary"

# the suite must notice a wrong fare formula
MUT="$TM_TMP/mutant"
rm -rf "$MUT"; mkdir -p "$MUT"; cp -R ./. "$MUT"/
python3 - "$MUT/fares.tf" <<'PY'
import sys
p = sys.argv[1]
s = open(p).read()
t = s.replace("(var.axles - 1) * local.per_axle_cents", "var.axles * local.per_axle_cents")
open(p, "w").write(t)
sys.exit(0 if t != s else 3)
PY
if [[ $? -eq 0 ]]; then
  if (cd "$MUT" && terraform test -no-color) >"$TM_TMP/mutant.out" 2>&1; then
    tm_fail "the tests still pass when the axle arithmetic is wrong - they are not really checking the fare"
  fi
fi
tm_pass "3 scenarios run, and the suite catches a broken fare formula"
