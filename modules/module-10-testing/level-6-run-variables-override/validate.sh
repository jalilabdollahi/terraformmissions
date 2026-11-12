#!/usr/bin/env bash
source "$TM_LIB"

T=tests/coop.tftest.hcl
tm_assert_file "$T" "tests/coop.tftest.hcl is missing"
for r in roomy_coop crowded_coop bantam_flock; do
  tm_assert_config_has "^run[[:space:]]+\"$r\"" "run \"$r\" is missing"
done
grep -qE 'coop_sqft[[:space:]]*=[[:space:]]*40[[:space:]]*$' "$T" \
  || tm_fail "crowded_coop must still override coop_sqft with the number 40"
python3 - "$T" <<'PY'
import re, sys
t = open(sys.argv[1]).read()
m = re.search(r'stock\s*=\s*\{([^}]*)\}', t)
ok = m and re.search(r'bantam\s*=\s*30\b', m.group(1))
sys.exit(0 if ok else 1)
PY
[[ $? -eq 0 ]] || tm_fail "bantam_flock must override stock with a map holding bantam = 30"
grep -qE 'type[[:space:]]*=[[:space:]]*map\(number\)' coop.tf \
  && grep -qE 'type[[:space:]]*=[[:space:]]*number' coop.tf \
  || tm_fail "coop.tf must keep its strict variable types"

tm_tf test || true
if grep -qE 'Invalid value for input variable' "$TM_LAST_OUT"; then
  tm_show_last
  tm_fail "a run override has a type the variable does not accept"
fi
summary=$(grep -E '^(Success|Failure)!' "$TM_LAST_OUT")
[[ "$summary" == "Success! 3 passed, 0 failed." ]] || tm_fail "terraform test says: ${summary:-no summary}"

# raising the threshold bug: crowded scenarios must start to fail if the flag is wrong
D="$TM_TMP/mutant"
rm -rf "$D"; mkdir -p "$D"; cp -R ./. "$D"/
python3 - "$D/coop.tf" <<'PY'
import sys
p = sys.argv[1]
s = open(p).read()
t = s.replace("local.per_hen < 5", "local.per_hen < 2")
open(p, "w").write(t)
sys.exit(0 if s != t else 3)
PY
if [[ $? -eq 0 ]] && (cd "$D" && terraform test -no-color) >"$TM_TMP/mutant.out" 2>&1; then
  tm_fail "the suite passes even if the overstocked threshold is far too lenient"
fi
tm_pass "overrides have the right types and the crowded scenarios really exercise the flag"
