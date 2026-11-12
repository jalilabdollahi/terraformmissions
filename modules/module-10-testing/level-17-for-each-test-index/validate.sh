#!/usr/bin/env bash
source "$TM_LIB"

T=tests/concours.tftest.hcl
tm_assert_file "$T" "tests/concours.tftest.hcl is missing"
tm_assert_config_has 'stand_card\["arrow"\]' "the roadster instance is not addressed by its key"
tm_assert_config_has 'stand_card\["regent"\]' "the saloon instance is not addressed by its key"
tm_assert_config_has 'Stand 3: arrow \(roadster\)' "the roadster card text check has been removed"
tm_assert_config_has 'Stand 7' "the regent stand check has been removed"
tm_assert_config_has 'length\(local_file\.stand_card\)[[:space:]]*==[[:space:]]*3' "the three-card check has been removed"
tm_assert_config_lacks 'stand_card\[[0-9]' "an instance is still addressed by a number"
tm_assert_config_lacks 'stand_card\["[A-Z]' "an instance key has the wrong case"
tm_assert_config_has 'for_each[[:space:]]*=[[:space:]]*var\.entries' "the cards must stay a for_each over var.entries"

tm_tf test -verbose
if [[ $? -ne 0 ]]; then
  tm_show_last
  tm_fail "terraform test is still failing"
fi
grep -q '^Success! 3 passed, 0 failed' "$TM_LAST_OUT" || tm_fail "three runs must pass"

twist() {
  local why="$1" old="$2" new="$3" d="$TM_TMP/twist-$1"
  rm -rf "$d"; mkdir -p "$d"; cp -R ./. "$d"/
  python3 - "$d/concours.tf" "$old" "$new" <<'PY'
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
twist "stand numbers are off by one" 'Stand ${each.value.stand}' 'Stand ${each.value.stand + 1}'
twist "cards get another extension" 'cards/${each.key}.txt' 'cards/${each.key}.md'
twist "a entry loses its card" 'for_each = var.entries' 'for_each = { for k, v in var.entries : k => v if k != "falcon" }'
tm_pass "cards are checked by key, as a whole, and three injected bugs are caught"
