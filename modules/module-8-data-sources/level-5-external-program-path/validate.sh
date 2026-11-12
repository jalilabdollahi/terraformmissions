#!/usr/bin/env bash
source "$TM_LIB"

for probe in bore air damp; do
  tm_assert_config_has "data[[:space:]]+\"external\"[[:space:]]+\"$probe\"" "data.external.$probe must stay in the config"
done
for f in bore-depth.sh air-quality.py humidity.sh; do
  tm_assert_file "probes/$f" "probes/$f has been removed"
done

tm_apply
tm_assert_output depth_m 84
tm_assert_output o2_pct 19.6
tm_assert_output humidity_pct 97
tm_assert_file_contains camp/board.txt "Oxygen: 19.6% (breathable)"

cp survey/readings.txt "$TM_TMP/readings.orig"
trap 'cp "$TM_TMP/readings.orig" survey/readings.txt' EXIT
printf 'depth_m=120\no2_pct=18.9\nhumidity_pct=88\n' > survey/readings.txt
tm_apply
tm_assert_output depth_m 120
tm_assert_output o2_pct 18.9
tm_assert_output humidity_pct 88
tm_assert_file_contains camp/board.txt "NO ENTRY" "the board did not follow the new oxygen reading"
tm_pass "all three probes run and report what survey/readings.txt says"
