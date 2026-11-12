#!/usr/bin/env bash
source "$TM_LIB"

F=tests/pairings.tftest.hcl
tm_assert_file "$F" "tests/pairings.tftest.hcl is missing"

# structure: one unindented variables block, runs keep their own override
python3 - "$F" <<'PY'
import re, sys
text = open(sys.argv[1]).read()
top = re.findall(r'^variables\s*\{', text, re.M)
runs = re.findall(r'^run\s+"([^"]+)"', text, re.M)
if len(top) != 1:
    print("need exactly one file-level variables block, found %d" % len(top)); sys.exit(2)
if sorted(runs) != ["even_roster", "odd_roster_gets_bye"]:
    print("expected runs even_roster and odd_roster_gets_bye, found %s" % runs); sys.exit(3)
body = text.split('run "odd_roster_gets_bye"', 1)[1]
if not re.search(r'^\s+variables\s*\{[^}]*players', body, re.M | re.S):
    print("odd_roster_gets_bye must override players in its own variables block"); sys.exit(4)
head = text.split('run "', 1)[0]
if "club" not in head or "players" not in head:
    print("the file-level block must supply both club and players"); sys.exit(5)
PY
rc=$?
[[ $rc -eq 0 ]] || tm_fail "test file structure is wrong (check $rc): see the block layout the mission asks for"

# the code keeps its inputs required
grep -qE 'default[[:space:]]*=' pairings.tf && tm_fail "pairings.tf must keep club and players as required inputs (no defaults)"

terraform test -no-color >"$TM_LAST_OUT" 2>&1 || { tm_show_last; tm_fail "terraform test is not passing yet"; }
grep -q '^Success! 2 passed, 0 failed' "$TM_LAST_OUT" || tm_fail "expected 2 passing runs"

# a bug in the bye arithmetic must be caught
D="$TM_TMP/odd-bug"
rm -rf "$D"; mkdir -p "$D"; cp -R ./. "$D"/
python3 - "$D/pairings.tf" <<'PY'
import sys
p = sys.argv[1]
s = open(p).read()
t = s.replace("ceil(length(var.players) / 2)", "floor(length(var.players) / 2)")
open(p, "w").write(t)
sys.exit(0 if s != t else 3)
PY
if [[ $? -eq 0 ]] && (cd "$D" && terraform test -no-color) >"$TM_TMP/odd-bug.out" 2>&1; then
  tm_fail "the suite does not notice when odd rosters lose a board"
fi
tm_pass "file-level variables feed both runs and the override only touches players"
