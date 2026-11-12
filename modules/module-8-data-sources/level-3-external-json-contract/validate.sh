#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"external"' "the load must still be read through the external data source"
[[ -x bin/manifest.py ]] || tm_fail "bin/manifest.py must stay executable"

tm_apply
tm_assert_output total_kg 303
tm_assert_output headroom_kg 57
tm_assert_output_jq passenger_names '. == ["Odile Fairweather","Tobias Wren","Marguerite Quill","Bertrand Lyle"]' \
  "passenger_names should list the four passengers from the csv, in order"
tm_assert_file_contains out/flight-card.txt "Passengers (4):"
tm_assert_file_contains out/flight-card.txt "headroom 57 kg"

# Edit the manifest: the numbers must be recomputed by the program.
cp manifest/passengers.csv "$TM_TMP/pax.orig"
trap 'cp "$TM_TMP/pax.orig" manifest/passengers.csv' EXIT
printf 'name,weight_kg\nIsolde Crane,70\nFinn Ostler,81\n' > manifest/passengers.csv
tm_apply
tm_assert_output total_kg 151
tm_assert_output headroom_kg 209
tm_assert_output_jq passenger_names '. == ["Isolde Crane","Finn Ostler"]' "the passenger list did not follow the edited csv"
tm_assert_file_contains out/flight-card.txt "Passengers (2):"
tm_pass "the program speaks the external contract and the flight card follows the manifest"
