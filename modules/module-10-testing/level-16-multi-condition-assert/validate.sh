#!/usr/bin/env bash
source "$TM_LIB"

T=tests/routes.tftest.hcl
tm_assert_file "$T" "tests/routes.tftest.hcl is missing"

python3 - "$T" <<'PY'
import re, sys
text = open(sys.argv[1]).read()
conds = re.findall(r'^\s*condition\s*=\s*(.+)$', text, re.M)
msgs = re.findall(r'^\s*error_message\s*=\s*"([^"]*)"', text, re.M)
if len(conds) < 7:
    print("only %d asserts: each fact needs its own (expected at least 7)" % len(conds)); sys.exit(2)
if any('&&' in c for c in conds):
    print("a condition still chains facts with &&"); sys.exit(3)
if len(set(msgs)) != len(msgs) or len(msgs) != len(conds):
    print("every assert needs its own, different error_message"); sys.exit(4)
if any(len(m) < 15 or "is wrong" in m for m in msgs):
    print("messages must state the expectation (at least 15 characters, not 'is wrong')"); sys.exit(5)
need = ['bolts == 9', 'bolts == 12', '"green"', '"red"', 'top_rope_ok']
for n in need:
    if n not in text:
        print("the fact %s is no longer asserted" % n); sys.exit(6)
PY
rc=$?
[[ $rc -eq 0 ]] || tm_fail "the assertions are not split into precise, clearly-worded checks (check $rc)"
[[ "$(grep -c '^run "' "$T")" -eq 2 ]] || tm_fail "both runs (classic_route, tall_route) must remain"

tm_tf test -verbose
if [[ $? -ne 0 ]]; then
  tm_show_last
  tm_fail "terraform test is still failing"
fi
grep -q '^Success! 2 passed, 0 failed' "$TM_LAST_OUT" || tm_fail "both runs must pass"

# the card itself must be right (not only the test)
CARD="$TM_TMP/card"
rm -rf "$CARD"; mkdir -p "$CARD"; cp -R ./. "$CARD"/
(cd "$CARD" && terraform apply -auto-approve -no-color) >"$TM_TMP/card.out" 2>&1 || tm_fail "the configuration does not apply"
bolts=$(cd "$CARD" && terraform output -json route | jq -r '.bolts')
[[ "$bolts" == "9" ]] || tm_fail "the real route card says $bolts bolts for a 17 m route"

sab() {
  local why="$1" old="$2" new="$3" d="$TM_TMP/sab-$1"
  rm -rf "$d"; mkdir -p "$d"; cp -R ./. "$d"/
  python3 - "$d/routes.tf" "$old" "$new" <<'PY'
import sys
p, a, b = sys.argv[1:4]
s = open(p).read()
t = s.replace(a, b)
open(p, "w").write(t)
sys.exit(0 if s != t else 3)
PY
  [[ $? -eq 0 ]] || return 0
  (cd "$d" && terraform test -no-color) >"$TM_TMP/sab.out" 2>&1 && tm_fail "the suite passes although $why"
}
sab "6a holds turn blue" '"6a" = "green"' '"6a" = "blue"'
sab "top rope is allowed on tall walls" 'var.height_m <= 20' 'var.height_m <= 30'
sab "bolts are rounded down again" 'ceil(var.height_m / 2)' 'floor(var.height_m / 2)'
tm_pass "one fact per assert, each with a clear message, and the bolt count is fixed at the source"
