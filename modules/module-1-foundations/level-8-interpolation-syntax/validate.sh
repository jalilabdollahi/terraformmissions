#!/usr/bin/env bash
source "$TM_LIB"

tm_validate
tm_apply
tm_assert_file_equals weather/bulletin.txt $'Station: Kestrel Ridge\nAltitude: 1840 m\nWind: 23 knots\n' \
  "the bulletin still shows unresolved text instead of the variable values"
tm_apply -var 'station=Osprey Pass' -var 'altitude_m=2210' -var 'wind_knots=41'
tm_assert_file_equals weather/bulletin.txt $'Station: Osprey Pass\nAltitude: 2210 m\nWind: 41 knots\n' \
  "the bulletin must follow the variables, not hard-coded values"
tm_apply
tm_assert_no_changes
tm_pass "all three values are interpolated from their variables"
