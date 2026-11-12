#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'var\.items' "the tags must be computed from var.items"
tm_assert_config_lacks '"(umbrella|scarf|keys|thermos): ' "do not type the tag lines into the config"

tm_validate "the configuration does not evaluate"
tm_apply
tm_assert_no_changes
tm_assert_no_changes

EXPECTED=$'keys: Brass key ring | holder=S. LINDQVIST | phone=n/a\nscarf: Red wool scarf | holder=UNCLAIMED | phone=n/a\nthermos: Steel thermos | holder=UNCLAIMED | phone=n/a\numbrella: Black umbrella | holder=M. OKAFOR | phone=555-0101\n'
tm_assert_file_equals cage/tags.txt "$EXPECTED" "cage/tags.txt does not match the required tag format"
tm_assert_output tag_count "4"

# Different input: only the logic can produce the right text.
tm_plan_json -var 'items={glove={description="Left glove"}, hat={description="Blue hat", claim={holder="r. dale"}}}'
CONTENT=$(jq -r '.resource_changes[] | select(.address == "local_file.tag_sheet") | .change.after.content' "$TM_TMP/plan.json")
WANT=$'glove: Left glove | holder=UNCLAIMED | phone=n/a\nhat: Blue hat | holder=R. DALE | phone=n/a\n'
[[ "$CONTENT" == "${WANT%$'\n'}" ]] \
  || tm_fail "with different items the sheet reads '$CONTENT' - the guard must work for any item, not just the defaults"
tm_pass "claimed and unclaimed items both produce a proper tag"
