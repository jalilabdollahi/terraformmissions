#!/usr/bin/env bash
source "$TM_LIB"

T=tests/tank.tftest.hcl
tm_assert_file "$T" "tests/tank.tftest.hcl is missing"
for r in roomy_tank crowded_tank guppy_swarm; do
  tm_assert_config_has "^run[[:space:]]+\"$r\"" "run \"$r\" is missing"
done
grep -qE 'tank_liters[[:space:]]*=[[:space:]]*40[[:space:]]*$' "$T" \
  || tm_fail "crowded_tank must still override tank_liters with the number 40"
python3 - "$T" <<'PY'
import re, sys
t = open(sys.argv[1]).read()
m = re.search(r'stock\s*=\s*\{([^}]*)\}', t)
ok = m and re.search(r'guppy\s*=\s*30\b', m.group(1))
sys.exit(0 if ok else 1)
PY
[[ $? -eq 0 ]] || tm_fail "guppy_swarm must override stock with a map holding guppy = 30"
grep -qE 'type[[:space:]]*=[[:space:]]*map\(number\)' tank.tf \
  && grep -qE 'type[[:space:]]*=[[:space:]]*number' tank.tf \
  || tm_fail "tank.tf must keep its strict variable types"

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
python3 - "$D/tank.tf" <<'PY'
import sys
p = sys.argv[1]
s = open(p).read()
t = s.replace("local.per_fish < 5", "local.per_fish < 2")
open(p, "w").write(t)
sys.exit(0 if s != t else 3)
PY
if [[ $? -eq 0 ]] && (cd "$D" && terraform test -no-color) >"$TM_TMP/mutant.out" 2>&1; then
  tm_fail "the suite passes even if the overstocked threshold is far too lenient"
fi
tm_pass "overrides have the right types and the crowded scenarios really exercise the flag"
