#!/usr/bin/env bash
source "$TM_LIB"

T=tests/rally.tftest.hcl
tm_assert_file "$T" "tests/rally.tftest.hcl is missing"
tm_assert_config_has 'board_card\["tacotl"\]' "the taco truck instance is not addressed by its key"
tm_assert_config_has 'board_card\["pierogi"\]' "the pierogi truck instance is not addressed by its key"
tm_assert_config_has 'Pitch 3: tacotl \(mexican\)' "the taco card text check has been removed"
tm_assert_config_has 'Pitch 7' "the pierogi pitch check has been removed"
tm_assert_config_has 'length\(local_file\.board_card\)[[:space:]]*==[[:space:]]*3' "the three-card check has been removed"
tm_assert_config_lacks 'board_card\[[0-9]' "an instance is still addressed by a number"
tm_assert_config_lacks 'board_card\["[A-Z]' "an instance key has the wrong case"
tm_assert_config_has 'for_each[[:space:]]*=[[:space:]]*var\.trucks' "the cards must stay a for_each over var.trucks"

tm_tf test -verbose
if [[ $? -ne 0 ]]; then
  tm_show_last
  tm_fail "terraform test is still failing"
fi
grep -q '^Success! 3 passed, 0 failed' "$TM_LAST_OUT" || tm_fail "three runs must pass"

twist() {
  local why="$1" old="$2" new="$3" d="$TM_TMP/twist-$1"
  rm -rf "$d"; mkdir -p "$d"; cp -R ./. "$d"/
  python3 - "$d/rally.tf" "$old" "$new" <<'PY'
import sys
p, a, b = sys.argv[1:4]
s = open(p).read()
t = s.replace(a, b)
open(p, "w").write(t)
sys.exit(0 if s != t else 3)
PY
  [[ $? -eq 0 ]] || return 0
  (cd "$d" && terraform test -no-color) >"$TM_TMP/twist.out" 2>&1 && tm_fail "the suite passes although $why"
}
twist "pitch numbers are off by one" 'Pitch ${each.value.pitch}' 'Pitch ${each.value.pitch + 1}'
twist "cards get another extension" 'cards/${each.key}.txt' 'cards/${each.key}.md'
twist "a truck loses its card" 'for_each = var.trucks' 'for_each = { for k, v in var.trucks : k => v if k != "waffle" }'
tm_pass "cards are checked by key, as a whole, and three injected bugs are caught"
