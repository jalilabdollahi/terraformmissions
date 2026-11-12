#!/usr/bin/env bash
source "$TM_LIB"

T=tests/sailloft.tftest.hcl
tm_assert_file "$T" "tests/sailloft.tftest.hcl is missing"
order=$(grep -oE '^run[[:space:]]+"[a-z_]+"' "$T" | sed -E 's/run[[:space:]]+//; s/"//g' | tr '\n' ' ')
[[ "$order" == "measure_main order_cloth spare_jib " ]] \
  || tm_fail "the runs must be measure_main, order_cloth, spare_jib in that order (found: $order)"
tm_assert_config_has 'order_area_m2[[:space:]]*=[[:space:]]*run\.measure_main\.sail_area' \
  "order_cloth must take its area from the measure_main run's sail_area output"
tm_assert_config_has 'run\.order_cloth\.cloth_ordered_m2' "spare_jib must compare against the order_cloth run"
tm_assert_config_lacks 'order_area_m2[[:space:]]*=[[:space:]]*[0-9]' "order_cloth hard-codes the area instead of chaining it"

tm_tf test -verbose
code=$?
if [[ $code -ne 0 ]]; then
  tm_show_last
  tm_fail "terraform test is still failing"
fi
grep -q '^Success! 3 passed, 0 failed' "$TM_LAST_OUT" || tm_fail "three passing runs expected"

mutation() {
  local tag="$1" old="$2" new="$3" d="$TM_TMP/mut-$1"
  rm -rf "$d"; mkdir -p "$d"; cp -R ./. "$d"/
  python3 - "$d/sailloft.tf" "$old" "$new" <<'PY'
import sys
p, a, b = sys.argv[1:4]
s = open(p).read()
t = s.replace(a, b)
open(p, "w").write(t)
sys.exit(0 if s != t else 3)
PY
  [[ $? -eq 0 ]] || return 0
  if (cd "$d" && terraform test -no-color) >"$TM_TMP/mut-$tag.out" 2>&1; then
    tm_fail "the suite does not catch: $tag"
  fi
}
mutation "sail area uses the wrong fraction" '0.5 * var.luff_m' '0.6 * var.luff_m'
mutation "waste allowance dropped from the cloth order" '* 1.1)' '* 1.0)'
tm_pass "runs are ordered and chained, and two injected bugs are caught"
