#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "local_file" "cargo_manifest"' "the cargo manifest must stay in the configuration"
tm_assert_config_has 'resource "random_pet" "pilot"' "the pilot resource must stay in the configuration"
tm_assert_config_has 'customs-stamp\.txt' "the customs precondition was removed — the cargo manifest must keep waiting for the stamp"
tm_assert_config_has 'precondition' "the customs precondition was removed"
tm_assert_no_file pending/customs-stamp.txt "someone faked the customs stamp"

tm_assert_in_state local_file.route_chart "the route chart has not been applied yet"
tm_assert_in_state random_id.route_code "the route code is not in state — the chart depends on it"
tm_assert_not_in_state random_pet.pilot "random_pet.pilot was created too — only the route chart was supposed to be applied"
tm_assert_not_in_state local_file.cargo_manifest "the cargo manifest was applied although customs has not cleared it"
tm_assert_no_file out/cargo-manifest.txt "out/cargo-manifest.txt exists, but customs has not cleared the cargo"

tm_assert_file out/route-chart.txt "out/route-chart.txt was not written"
CODE=$(tm_state_attr random_id.route_code hex)
tm_assert_file_contains out/route-chart.txt "$CODE" "the chart does not show the route code from state"
tm_pass "the route chart ($CODE) is published; pilot and cargo are still waiting"
