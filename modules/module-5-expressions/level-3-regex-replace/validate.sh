#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'replace[[:space:]]*\(' "keep using replace() on the raw inputs"

tm_apply
tm_assert_output serial_key "ZX4411B09"
tm_assert_output fault_note "Tape loader failing, border flickers on boot"
tm_assert_output intake_uk "17/03/2026"
tm_assert_file_equals tags/bench-tag.txt "Serial: ZX4411B09
Fault: Tape loader failing, border flickers on boot
In: 17/03/2026
"

# Different inputs must be cleaned by the same expressions.
tm_plan_json -var 'serial_raw= gr.20 / x-7 ' -var 'fault_note_raw= keys stick    when   warm ' -var 'intake_date=1999-12-01'
for pair in 'serial_key|GR20X7' 'fault_note| keys stick when warm ' 'intake_uk|01/12/1999'; do
  name=${pair%%|*}; want=${pair#*|}
  got=$(jq -r ".planned_values.outputs.$name.value" "$TM_TMP/plan.json")
  [[ "$got" == "$want" ]] || tm_fail "output '$name' is '$got' for the second input set, expected '$want'"
done
tm_pass "serial, fault note and date are all cleaned by regex replace(), whatever the input"
