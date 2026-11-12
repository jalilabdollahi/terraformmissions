#!/usr/bin/env bash
source "$TM_LIB"

T=tests/pacing.tftest.hcl
tm_assert_file "$T" "tests/pacing.tftest.hcl is missing"
n_run=$(grep -cE '^[[:space:]]*run[[:space:]]+"' "$T")
n_assert=$(grep -cE '^[[:space:]]*assert[[:space:]]*\{' "$T")
[[ "$n_run" -ge 2 && "$n_assert" -ge 4 ]] \
  || tm_fail "the suite must keep both runs and all four asserts (runs=$n_run, asserts=$n_assert)"
tm_assert_config_has 'pace_sec_per_km[[:space:]]*=[[:space:]]*540' "the slow_runner scenario no longer sets a 540 s/km pace"
tm_assert_config_lacks 'condition[[:space:]]*=[[:space:]]*true' "an assert has been replaced by a constant"

terraform test -no-color >"$TM_LAST_OUT" 2>&1
if [[ $? -ne 0 ]]; then
  tm_show_last
  tm_fail "terraform test still reports failures"
fi
res=$(grep -E '^Success! [0-9]+ passed, 0 failed' "$TM_LAST_OUT")
[[ "$res" == "Success! 2 passed, 0 failed." ]] || tm_fail "expected both runs to pass, got: ${res:-no summary}"

# The code under test must still be the real thing: if the fix was to bend the code, the mutants below expose it
check_mutant() {
  local label="$1" old="$2" new="$3" d="$TM_TMP/m-$1"
  rm -rf "$d"; mkdir -p "$d"; cp -R ./. "$d"/
  python3 - "$d/pacing.tf" "$old" "$new" <<'PY'
import sys
path, old, new = sys.argv[1:4]
src = open(path).read()
out = src.replace(old, new)
open(path, "w").write(out)
sys.exit(0 if out != src else 3)
PY
  [[ $? -eq 0 ]] || return 0
  if (cd "$d" && terraform test -no-color) >"$TM_TMP/m-$1.out" 2>&1; then
    tm_fail "the tests still pass when the code has a bug ($label)"
  fi
}
check_mutant cutoff_inverted '/ 60) < var.cutoff_minutes' '/ 60) >= var.cutoff_minutes'
check_mutant checkpoints_reversed 'value = [for km in local.checkpoints_km : floor(km * var.pace_sec_per_km / 60)]' 'value = reverse([for km in local.checkpoints_km : floor(km * var.pace_sec_per_km / 60)])'
check_mutant distance_rounded '42.195' '42'
tm_pass "all conditions state their intent and three injected bugs are caught"
