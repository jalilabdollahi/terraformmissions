#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "null_resource" "cue_sheet"' "null_resource.cue_sheet must stay"
tm_assert_config_has 'running_order[[:space:]]*=[[:space:]]*\[' "keep the running order as a list in locals"
tm_assert_config_has '(join|jsonencode)\(' "convert the list to a string with join() or jsonencode()"
tm_apply
CUES=$(terraform show -json 2>/dev/null | jq -r '.values.root_module.resources[] | select(.address=="null_resource.cue_sheet") | .values.triggers.cues // empty')
[[ -n "$CUES" ]] || tm_fail "the cues trigger is missing from null_resource.cue_sheet"
for c in opening-salvo river-cascade golden-rain grand-finale; do
  grep -qF "$c" <<<"$CUES" || tm_fail "cue '$c' is missing from the cues trigger: $CUES"
done
tm_assert_file_equals show/cues.txt "opening-salvo
river-cascade
golden-rain
grand-finale
"
tm_assert_output_jq cue_revision_id 'type == "string" and length > 0'
tm_assert_no_changes
tm_pass "triggers are strings and carry the whole running order"
