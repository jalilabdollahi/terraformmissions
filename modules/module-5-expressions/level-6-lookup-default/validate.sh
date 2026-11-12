#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'standard_ration_kg' "the fallback must come from var.standard_ration_kg"
tm_assert_config_lacks 'lookup[[:space:]]*\([^)]*,[[:space:]]*[0-9]+[[:space:]]*\)' "do not hard-code the fallback number inside lookup()"

tm_apply
tm_assert_output_jq feed_order '. == {"shire":28,"fjord":3,"shetland":1.2,"haflinger":3}' \
  "feed_order should give shire 28, fjord 3, shetland 1.2, haflinger 3"
tm_assert_output total_kg "35.2"
tm_assert_file_equals board/feed.txt "fjord: 3 kg
haflinger: 3 kg
shetland: 1.2 kg
shire: 28 kg
"

# Different standard ration and different horses.
tm_plan_json -var standard_ration_kg=7 -var 'horses=["welsh_cob","exmoor","shetland"]'
jq -e '.planned_values.outputs.feed_order.value == {"welsh_cob":9.5,"exmoor":7,"shetland":1.2}
  and .planned_values.outputs.total_kg.value == 17.7' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "unlisted breeds must get var.standard_ration_kg and listed ones their own ration (welsh_cob 9.5, exmoor 7, shetland 1.2)"
tm_pass "listed breeds keep their ration and every other horse falls back to the standard one"
