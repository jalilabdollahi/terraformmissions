#!/usr/bin/env bash
source "$TM_LIB"

T=tests/permit.tftest.hcl
tm_assert_file "$T" "tests/permit.tftest.hcl is missing"

python3 - "$T" <<'PY'
import re, sys
text = open(sys.argv[1]).read()
parts = re.split(r'^run\s+"', text, flags=re.M)[1:]
runs = {p.split('"', 1)[0]: p for p in parts}
for name in ("within_limits", "too_heavy", "too_tall"):
    if name not in runs:
        print("run %s is missing" % name); sys.exit(2)
for name, var, lo in (("too_heavy", "shell_kg", 40), ("too_tall", "rack_height_m", 4.5)):
    b = runs[name]
    if "expect_failures" not in b or "terraform_data.display_permit" not in b:
        print("%s must expect a failure on terraform_data.display_permit" % name); sys.exit(3)
    if re.search(r'expect_failures\s*=\s*\[[^\]]*var\.', b):
        print("%s expects a variable, which holds no precondition" % name); sys.exit(4)
    m = re.search(r'\b%s\s*=\s*([0-9.]+)' % var, b)
    if not m or float(m.group(1)) <= lo:
        print("%s must set %s above %s" % (name, var, lo)); sys.exit(5)
other = {"too_heavy": "rack_height_m", "too_tall": "shell_kg"}
for name, var in other.items():
    if re.search(r'\b%s\s*=' % var, runs[name]):
        print("%s must violate only its own rule" % name); sys.exit(6)
PY
rc=$?
[[ $rc -eq 0 ]] || tm_fail "negative runs are not set up correctly (check $rc): expect the failure on the resource and violate exactly one rule per run"

tm_tf test -verbose
if [[ $? -ne 0 ]]; then
  tm_show_last
  tm_fail "terraform test is failing"
fi
grep -q '^Success! 3 passed, 0 failed' "$TM_LAST_OUT" || tm_fail "three runs must pass"

disarm() {
  local rule="$1" old="$2" new="$3" d="$TM_TMP/disarm-$1"
  rm -rf "$d"; mkdir -p "$d"; cp -R ./. "$d"/
  python3 - "$d/permit.tf" "$old" "$new" <<'PY'
import sys
p, a, b = sys.argv[1:4]
s = open(p).read()
t = s.replace(a, b)
open(p, "w").write(t)
sys.exit(0 if s != t else 3)
PY
  [[ $? -eq 0 ]] || return 0
  (cd "$d" && terraform test -no-color) >"$TM_TMP/disarm.out" 2>&1 && tm_fail "the suite passes although the $rule precondition is disarmed"
}
disarm weight 'var.shell_kg <= 40' 'true'
disarm height 'var.rack_height_m <= 4.5' 'true'
tm_pass "each precondition has a negative run that names the resource and breaks only its own rule"
