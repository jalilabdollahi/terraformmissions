#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'standard_ration_kg' "the fallback must come from var.standard_ration_kg"
tm_assert_config_lacks 'lookup[[:space:]]*\([^)]*,[[:space:]]*[0-9]+[[:space:]]*\)' "do not hard-code the fallback number inside lookup()"

tm_apply
tm_assert_output_jq feed_order '. == {"giraffe":28,"okapi":3,"lemur":1.2,"capybara":3}' \
  "feed_order should give giraffe 28, okapi 3, lemur 1.2, capybara 3"
tm_assert_output total_kg "35.2"
tm_assert_file_equals board/feed.txt "capybara: 3 kg
giraffe: 28 kg
lemur: 1.2 kg
okapi: 3 kg
"

# Different standard ration and different animals.
tm_plan_json -var standard_ration_kg=7 -var 'animals=["tapir","meerkat","lemur"]'
jq -e '.planned_values.outputs.feed_order.value == {"tapir":9.5,"meerkat":7,"lemur":1.2}
  and .planned_values.outputs.total_kg.value == 17.7' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "unlisted species must get var.standard_ration_kg and listed ones their own ration (tapir 9.5, meerkat 7, lemur 1.2)"
tm_pass "listed species keep their ration and every other animal falls back to the standard one"
