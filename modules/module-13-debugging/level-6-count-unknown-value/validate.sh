#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'random_shuffle' "the flavours must still come from random_shuffle"
tm_assert_config_has 'tasting_card' "the tasting_card resource must stay"
tm_assert_config_lacks 'count[[:space:]]*=[^#]*random_shuffle' "count must not be derived from the shuffle result"
tm_assert_config_lacks '-target' "-target is not a fix - the config itself must be plannable"

tm_apply
tm_assert_no_changes
tm_assert_no_changes

SEEN=""
for i in 1 2 3; do
  f="cards/card-$i.txt"
  tm_assert_file "$f" "$f was not written"
  line=$(cat "$f")
  flavour=${line#*: }
  case "$line" in
    "Blind tasting #$i: "*) ;;
    *) tm_fail "$f has unexpected content: $line" ;;
  esac
  case " $SEEN " in
    *" $flavour "*) tm_fail "flavour '$flavour' appears twice - each card needs its own flavour" ;;
  esac
  SEEN="$SEEN $flavour"
done
[[ ! -e cards/card-4.txt ]] || tm_fail "there should be exactly three cards for panel_size = 3"

# The count must be known when planning with a different panel size.
tm_plan_json -var panel_size=4
ADDS=$(jq -r '[.resource_changes[] | select(.address | startswith("local_file.tasting_card")) | select(.change.actions == ["create"])] | length' "$TM_TMP/plan.json")
[[ "$ADDS" == "1" ]] || tm_fail "planning with panel_size=4 should add exactly one card, but would add $ADDS"
tm_pass "the card count is known at plan time and follows panel_size"
