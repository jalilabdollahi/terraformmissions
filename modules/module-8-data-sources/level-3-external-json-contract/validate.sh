#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"external"' "the load must still be read through the external data source"
[[ -x bin/weigh_in.py ]] || tm_fail "bin/weigh_in.py must stay executable"

tm_apply
tm_assert_output total_kg 303
tm_assert_output headroom_kg 57
tm_assert_output_jq jumper_names '. == ["Odile Fairweather","Tobias Wren","Marguerite Quill","Bertrand Lyle"]' \
  "jumper_names should list the four jumpers from the csv, in order"
tm_assert_file_contains out/jump-card.txt "Jumpers (4):"
tm_assert_file_contains out/jump-card.txt "headroom 57 kg"

# Edit the roster: the numbers must be recomputed by the program.
cp roster/jumpers.csv "$TM_TMP/jumpers.orig"
trap 'cp "$TM_TMP/jumpers.orig" roster/jumpers.csv' EXIT
printf 'name,weight_kg\nIsolde Crane,70\nFinn Ostler,81\n' > roster/jumpers.csv
tm_apply
tm_assert_output total_kg 151
tm_assert_output headroom_kg 209
tm_assert_output_jq jumper_names '. == ["Isolde Crane","Finn Ostler"]' "the jumper list did not follow the edited csv"
tm_assert_file_contains out/jump-card.txt "Jumpers (2):"
tm_pass "the program speaks the external contract and the jump card follows the roster"
