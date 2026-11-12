#!/usr/bin/env bash
source "$TM_LIB"

T=tests/colour.tftest.hcl
tm_assert_file "$T" "tests/colour.tftest.hcl is missing"
runs=$(grep -cE '^[[:space:]]*run[[:space:]]+"' "$T")
[[ "$runs" -eq 3 ]] || tm_fail "the suite should keep its three runs, found $runs"
tm_assert_config_has 'fileexists\(' "the on-disk check (fileexists) has been removed"
tm_assert_config_has 'pigment: 800 g' "the check that the card lists pigment at 800 g has been removed"

terraform test -no-color >"$TM_LAST_OUT" 2>&1
code=$?
if [[ $code -ne 0 ]]; then
  grep -E '^[[:space:]]+run "' "$TM_LAST_OUT" | sed 's/^/   | /'
  tm_fail "terraform test is failing"
fi
grep -q '^Success! 3 passed, 0 failed' "$TM_LAST_OUT" || tm_fail "expected 3 passed runs"
[[ ! -e salon/formula.txt ]] || tm_fail "salon/formula.txt was left behind - teardown did not remove it"

# Mutants: the suite must notice a wrong card and a card with the wrong layout
mutate() {
  local name="$1" old="$2" new="$3" dir="$TM_TMP/mutant-$1"
  rm -rf "$dir"; mkdir -p "$dir"; cp -R ./. "$dir"/
  python3 - "$dir/colour.tf" "$old" "$new" <<'PY'
import sys
p, old, new = sys.argv[1:4]
s = open(p).read()
t = s.replace(old, new)
open(p, "w").write(t)
sys.exit(0 if t != s else 3)
PY
  [[ $? -eq 0 ]] || return 0
  if (cd "$dir" && terraform test -no-color) >"$TM_TMP/mutant-$name.out" 2>&1; then
    tm_fail "the suite still passes when $name - the checks are too weak"
  fi
}
mutate "the card lists wrong quantities" 'part * var.batch_kg * 10' 'part * var.batch_kg * 12'
mutate "the card drops the unit suffix" '${name}: ${g} g' '${name}: ${g}'
tm_pass "all runs pass, the file is checked after a real apply, and both mutants are caught"
