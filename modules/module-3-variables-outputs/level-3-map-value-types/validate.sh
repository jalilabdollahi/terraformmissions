#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_lacks '(map\(any\)|=[[:space:]]*any[[:space:]]*$)' \
  "the point is to describe the shape precisely — don't fall back to 'any'"
tm_assert_config_has 'map\([[:space:]]*object' "the variable should be a map of objects"

tm_apply
tm_assert_output slowest_days "14"
tm_assert_output_jq trays_in_use '. == ["A","B","C"]' "trays_in_use should be [A, B, C]"
tm_assert_file_equals tags/muga.txt "muga: tray C, hatches in 12 days
"
[[ $(ls tags | wc -l | tr -d ' ') == "4" ]] || tm_fail "expected exactly 4 tag files, one per silkworm"

# days must really be a number inside the object: pass a quoted "oops" and expect a type error
out=$(terraform plan -no-color -input=false -var 'silkworms={x={days="soon",tray="A"}}' 2>&1)
grep -q "number" <<<"$out" && ! grep -q "Plan:" <<<"$out" \
  || tm_fail "the 'days' attribute should be typed as a number — a non-numeric value was accepted"
tm_pass "silkworms is a map of objects with a numeric days and a string tray"
