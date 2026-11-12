#!/usr/bin/env bash
source "$TM_LIB"

[[ -f tests/label.tftest.hcl ]] || tm_fail "tests/label.tftest.hcl is missing"
for r in default_label dose_too_high interval_too_short; do
  tm_assert_config_has "^run[[:space:]]+\"$r\"" "run \"$r\" has been removed"
done
tm_assert_config_has 'dose_mg[[:space:]]*=[[:space:]]*900' "dose_too_high no longer feeds an out-of-range dose"
tm_assert_config_has 'interval_hours[[:space:]]*=[[:space:]]*1[[:space:]]*$' "interval_too_short no longer feeds an out-of-range interval"
tm_assert_config_lacks 'variable\.(dose_mg|interval_hours)[[:space:]]*,?[[:space:]]*$' \
  "an expect_failures entry is not a valid checkable address"

# the validation rules in the code must still be there
n=$(grep -c 'validation {' label.tf)
[[ "$n" -eq 2 ]] || tm_fail "label.tf should still have both validation rules (found $n)"

tm_tf test -verbose || { tm_show_last; tm_fail "terraform test is still failing"; }
grep -q '^Success! 3 passed, 0 failed' "$TM_LAST_OUT" || tm_fail "all three runs must pass"
for r in dose_too_high interval_too_short; do
  grep -qE "run \"$r\"\.\.\. pass" "$TM_LAST_OUT" || tm_fail "run $r did not report pass"
done

# each guardrail, removed, must make the suite fail
try_without() {
  local label="$1" old="$2" new="$3" d="$TM_TMP/no-$1"
  rm -rf "$d"; mkdir -p "$d"; cp -R ./. "$d"/
  python3 - "$d/label.tf" "$old" "$new" <<'PY'
import sys
p, a, b = sys.argv[1:4]
s = open(p).read()
t = s.replace(a, b)
open(p, "w").write(t)
sys.exit(0 if s != t else 3)
PY
  [[ $? -eq 0 ]] || return 0
  if (cd "$d" && terraform test -no-color) >"$TM_TMP/no-$label.out" 2>&1; then
    tm_fail "the suite passes even when the $label guardrail is removed"
  fi
}
try_without dose 'var.dose_mg > 0 && var.dose_mg <= 500' 'true'
try_without interval 'var.interval_hours >= 4' 'true'
tm_pass "both guardrails are tested with correct expect_failures addresses"
