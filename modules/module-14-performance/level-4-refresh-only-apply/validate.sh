#!/usr/bin/env bash
source "$TM_LIB"

OLD_BANNER=$(tm_recall banner)
[[ -n "$OLD_BANNER" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'umbrella sensor' "the unreviewed banner edit in variables.tf must not be thrown away"
tm_assert_config_has 'data "local_file" "gauge_feed"' "the gauge_feed data source has to stay"

[[ "$(cat banner.txt)" == "$OLD_BANNER" ]] \
  || tm_fail "banner.txt changed — the unreviewed banner edit was applied to the live station"

expected_rain=$(jq -r '.rainfall_mm' feeds/gauge-07.json)
expected_time=$(jq -r '.updated' feeds/gauge-07.json)
[[ "$expected_rain" == "11.8" ]] || tm_fail "feeds/gauge-07.json was modified; the feed is owned by the logger"

actual=$(tm_output_raw latest_rainfall_mm) || tm_fail "output latest_rainfall_mm is missing from state"
[[ "$actual" == "$expected_rain" ]] \
  || tm_fail "Terraform still records latest_rainfall_mm = $actual, the feed says $expected_rain"
[[ "$(tm_output_raw feed_updated)" == "$expected_time" ]] \
  || tm_fail "output feed_updated is still stale"

tm_assert_in_state local_file.station_banner "the banner resource must stay in state"

# (exit codes of refresh-only plans that read data sources are not reliable, so read the verdict)
code=$(tm_plan_code -refresh-only)
if [[ "$code" == "1" ]] || ! grep -q 'No changes' "$TM_LAST_OUT"; then
  tm_show_last
  tm_fail "a refresh-only plan still finds drift that has not been accepted into state"
fi

# The unreviewed change must still be pending in a normal plan.
code=$(tm_plan_code)
[[ "$code" == "2" ]] || tm_fail "the banner edit should still be a pending change in a normal plan (exit 2), got $code"

tm_pass "state now records $expected_rain mm at $expected_time and the banner edit is still unapplied"
