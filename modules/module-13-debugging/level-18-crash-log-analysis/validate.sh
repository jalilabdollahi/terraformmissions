#!/usr/bin/env bash
source "$TM_LIB"

ANS=answers/crash.txt
tm_assert_file "$ANS" "answers/crash.txt does not exist - record what the crash log says"
get() { grep -E "^$1=" "$ANS" | head -n1 | cut -d= -f2- | tr -d '[:space:]'; }
RES=$(get crashed_resource)
KEY=$(get offending_key)
[[ "$RES" == "data.external.shaft_scan" ]] \
  || tm_fail "crashed_resource is '$RES' - the trace names the resource whose Read call panicked"
[[ "$KEY" == "readings" ]] \
  || tm_fail "offending_key is '$KEY' - the last lines of the crash report name the key that held the wrong type"

tm_assert_config_has 'data[[:space:]]+"external"[[:space:]]+"shaft_scan"' "the shaft scan data source must stay - the report must come from the probe"
tm_assert_file scripts/probe.py "scripts/probe.py is gone - the readings must still come from the probe"
tm_assert_config_lacks '311' "the deepest reading must be computed from the probe's data, not typed in"
tm_assert_config_has 'max\(' "the deepest reading must still be computed with max()"

tm_apply
tm_assert_no_changes
tm_assert_no_changes

tm_assert_output deepest_m "311"
tm_assert_file_equals reports/shaft-b.txt "Shaft B inspected by R. Voss: deepest reading 311 m"$'\n' \
  "reports/shaft-b.txt does not match the mission text"
tm_pass "the probe's nested readings no longer crash the data source ($RES / $KEY)"
