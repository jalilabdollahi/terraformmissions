#!/usr/bin/env bash
source "$TM_LIB"

T=tests/ticket.tftest.hcl
tm_assert_file "$T" "tests/ticket.tftest.hcl is missing"
tm_assert_config_has 'station-3/scoops-8' "the default ticket assertion has been removed"
tm_assert_config_has 'run\.ticket_default\.ticket' "the reprint assertion has been removed"
n=$(grep -cE '^[[:space:]]*override_resource[[:space:]]*\{' "$T")
[[ "$n" -ge 2 ]] || tm_fail "expected two override_resource blocks, found $n"
[[ -f modules/glitter/main.tf ]] || tm_fail "the glitter module is gone"

tm_tf test -verbose
rc=$?
if grep -q 'Invalid override target' "$TM_LAST_OUT"; then
  grep -A2 'Invalid override target' "$TM_LAST_OUT" | sed 's/^/   | /'
  tm_fail "an override_resource target does not exist in the configuration"
fi
if [[ $rc -ne 0 ]]; then
  tm_show_last
  tm_fail "terraform test is failing"
fi
grep -q '^Success! 2 passed, 0 failed' "$TM_LAST_OUT" || tm_fail "both runs must pass"

# format bugs must be caught; and the overrides are only meaningful if the real addresses exist
flip() {
  local label="$1" file="$2" old="$3" new="$4" d="$TM_TMP/flip-$1"
  rm -rf "$d"; mkdir -p "$d"; cp -R ./. "$d"/
  python3 - "$d/$file" "$old" "$new" <<'PY'
import sys
p, a, b = sys.argv[1:4]
s = open(p).read()
t = s.replace(a, b)
open(p, "w").write(t)
sys.exit(0 if s != t else 3)
PY
  [[ $? -eq 0 ]] || return 0
  if (cd "$d" && terraform test -no-color) >"$TM_TMP/flip.out" 2>&1; then
    tm_fail "the suite passes although $label"
  fi
}
flip "the ticket prefix is wrong" ticket.tf '"station-${' '"slot-${'
flip "the module no longer feeds the ticket" ticket.tf 'module.glitter.scoops' '99'
flip "the root resource is renamed" ticket.tf 'resource "random_integer" "station_slot"' 'resource "random_integer" "station_slot_renamed"'
tm_pass "every override target resolves and the ticket assertions bite"
