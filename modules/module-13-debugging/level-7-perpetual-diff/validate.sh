#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_lacks 'ignore_changes' "ignore_changes hides the diff instead of removing its cause"
tm_assert_config_lacks 'timestamp\(\)' "timestamp() is re-evaluated on every plan"
tm_assert_config_lacks 'lifecycle' "no lifecycle tricks - remove the cause of the churn"
tm_assert_config_has 'data[[:space:]]+"external"' "the card list must still come from the cabinet script"

tm_apply
for round in 1 2 3 4; do
  tm_assert_no_changes
done

IDX=album/index.md
tm_assert_file "$IDX" "album/index.md was not written"
STAMP=$(grep '^Generated: ' "$IDX" | head -n1 | sed 's/^Generated: //')
[[ "$STAMP" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]] \
  || tm_fail "the Generated line is not an RFC 3339 UTC timestamp: '$STAMP'"
grep '^- ' "$IDX" >"$TM_TMP/cards.txt"
[[ "$(wc -l <"$TM_TMP/cards.txt" | tr -d ' ')" == "5" ]] || tm_fail "the index should list five cards"
sort -c "$TM_TMP/cards.txt" 2>/dev/null || tm_fail "the cards must be listed alphabetically"
tm_assert_output card_count 5

# the stamp must survive another round of plan + apply
tm_apply
[[ "$(grep '^Generated: ' "$IDX" | head -n1 | sed 's/^Generated: //')" == "$STAMP" ]] \
  || tm_fail "the Generated timestamp changed on re-apply"
tm_pass "plans are stable and the index is deterministic"
