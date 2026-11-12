#!/usr/bin/env bash
source "$TM_LIB"

T=tests/paint.tftest.hcl
tm_assert_file "$T" "tests/paint.tftest.hcl is missing"

python3 - "$T" <<'PY'
import re, sys
text = open(sys.argv[1]).read()
blocks = re.split(r'^run\s+"', text, flags=re.M)[1:]
modes = {}
for b in blocks:
    name = b.split('"', 1)[0]
    m = re.search(r'^\s*command\s*=\s*(plan|apply)', b, re.M)
    modes[name] = m.group(1) if m else "apply"
need = {"ratio_label": "plan", "batch_code_shape": "apply", "tint_in_range": "apply"}
for k, v in need.items():
    if k not in modes:
        print("run %s is missing" % k); sys.exit(2)
    if modes[k] != v:
        print("run %s should use command = %s" % (k, v)); sys.exit(3)
PY
rc=$?
[[ $rc -eq 0 ]] || tm_fail "run commands are not right (check code $rc) - which runs read values only an apply can produce?"
tm_assert_config_has 'regex\(' "the batch code shape assertion has been removed"
tm_assert_config_has 'output\.tint_number[[:space:]]*>=[[:space:]]*10' "the tint range assertion has been removed"

tm_tf test || { tm_show_last; tm_fail "terraform test is failing"; }
grep -q '^Success! 3 passed, 0 failed' "$TM_LAST_OUT" || tm_fail "expected 3 passing runs"

mutate() {
  local why="$1" old="$2" new="$3" d="$TM_TMP/mut-$1"
  rm -rf "$d"; mkdir -p "$d"; cp -R ./. "$d"/
  python3 - "$d/paint.tf" "$old" "$new" <<'PY'
import sys
p, a, b = sys.argv[1:4]
s = open(p).read()
t = s.replace(a, b)
open(p, "w").write(t)
sys.exit(0 if s != t else 3)
PY
  [[ $? -eq 0 ]] || return 0
  if (cd "$d" && terraform test -no-color) >"$TM_TMP/mut.out" 2>&1; then
    tm_fail "tests pass although $why"
  fi
}
mutate "batch codes get too short" 'byte_length = 4' 'byte_length = 2'
mutate "tint numbers fall outside 10-99" 'value = random_integer.tint.result' 'value = random_integer.tint.result + 100'
tm_pass "plan-time and apply-time claims are in the right runs, and bad random output is caught"
