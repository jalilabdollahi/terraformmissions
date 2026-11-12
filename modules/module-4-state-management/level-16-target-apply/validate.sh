#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "local_file" "load_manifest"' "the load manifest must stay in the configuration"
tm_assert_config_has 'resource "random_pet" "driver"' "the driver resource must stay in the configuration"
tm_assert_config_has 'weighbridge-ticket\.txt' "the weighbridge precondition was removed — the load manifest must keep waiting for the ticket"
tm_assert_config_has 'precondition' "the weighbridge precondition was removed"
tm_assert_no_file pending/weighbridge-ticket.txt "someone faked the weighbridge ticket"

tm_assert_in_state local_file.route_chart "the route chart has not been applied yet"
tm_assert_in_state random_id.route_code "the route code is not in state — the chart depends on it"
tm_assert_not_in_state random_pet.driver "random_pet.driver was created too — only the route chart was supposed to be applied"
tm_assert_not_in_state local_file.load_manifest "the load manifest was applied although weighbridge has not cleared it"
tm_assert_no_file out/load-manifest.txt "out/load-manifest.txt exists, but weighbridge has not cleared the load"

tm_assert_file out/route-chart.txt "out/route-chart.txt was not written"
CODE=$(tm_state_attr random_id.route_code hex)
tm_assert_file_contains out/route-chart.txt "$CODE" "the chart does not show the route code from state"
tm_pass "the route chart ($CODE) is published; driver and load are still waiting"
