#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'nullable[[:space:]]*=[[:space:]]*false' "the vault module should declare which inputs may not be null"
tm_assert_config_has 'retention_days[[:space:]]*=[[:space:]]*var\.retention_override' \
  "the root must keep passing var.retention_override straight through to the module"
tm_assert_config_lacks 'coalesce\(|retention_override[[:space:]]*\?' "the fallback belongs in the module's variable, not in the caller"

tm_apply
tm_assert_output effective_retention "30"
tm_assert_file_equals policies/cold-archive.txt "cold-archive keeps snapshots for 30 days
"

tm_plan_json -var retention_override=7
[[ "$(jq -r '.planned_values.outputs.effective_retention.value' "$TM_TMP/plan.json")" == "7" ]] \
  || tm_fail "an explicit override (7) should win over the default"
tm_pass "null from the caller falls back to the module default (30); an explicit value still wins"
