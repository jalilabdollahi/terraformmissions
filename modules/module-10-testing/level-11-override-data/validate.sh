#!/usr/bin/env bash
source "$TM_LIB"

T=tests/course.tftest.hcl
tm_assert_file "$T" "tests/course.tftest.hcl is missing"
tm_assert_no_file sensor/wind-kph.txt "sensor/wind-kph.txt must not exist: the tests have to fake the reading"
tm_assert_config_lacks 'override_resource' "override_resource cannot target a data source"

python3 - "$T" <<'PY'
import re, sys
text = open(sys.argv[1]).read()
blocks = re.split(r'^run\s+"', text, flags=re.M)[1:]
want = {"calm_morning": "6", "gale_warning": "34", "gusty_edge": "18"}
seen = {}
for b in blocks:
    name = b.split('"', 1)[0]
    if name in want:
        ok = re.search(r'override_data\s*\{[^}]*target\s*=\s*data\.local_file\.windmeter[^}]*values\s*=\s*\{[^}]*\bcontent\s*=\s*"?%s"?' % want[name], b, re.S)
        if not ok:
            print("%s needs override_data with content = %s" % (name, want[name])); sys.exit(2)
        seen[name] = True
if len(seen) != 3:
    print("one of the three scenarios has been removed"); sys.exit(3)
PY
[[ $? -eq 0 ]] || tm_fail "each scenario must override the windmeter reading with the value its name promises (a real attribute: content)"

tm_tf test -verbose
if [[ $? -ne 0 ]]; then
  tm_show_last
  tm_fail "terraform test is failing"
fi
grep -q '^Success! 3 passed, 0 failed' "$TM_LAST_OUT" || tm_fail "three runs must pass"

edit() {
  local why="$1" old="$2" new="$3" d="$TM_TMP/edit-$1"
  rm -rf "$d"; mkdir -p "$d"; cp -R ./. "$d"/
  python3 - "$d/course.tf" "$old" "$new" <<'PY'
import sys
p, a, b = sys.argv[1:4]
s = open(p).read()
t = s.replace(a, b)
open(p, "w").write(t)
sys.exit(0 if s != t else 3)
PY
  [[ $? -eq 0 ]] || return 0
  if (cd "$d" && terraform test -no-color) >"$TM_TMP/edit.out" 2>&1; then
    tm_fail "the suite passes although $why"
  fi
}
edit "the limit became inclusive" 'local.kph < 18' 'local.kph <= 18'
edit "the limit became far too high" 'local.kph < 18' 'local.kph < 40'
edit "the verdict is inverted" '"open" : "closed"' '"closed" : "open"'
tm_pass "all three readings are faked with override_data and the threshold is pinned from both sides"
