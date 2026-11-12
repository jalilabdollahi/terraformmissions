#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_lacks 'ignore_changes' "ignore_changes hides the diff instead of removing its cause"
tm_assert_config_lacks 'timestamp\(\)' "timestamp() is re-evaluated on every plan"
tm_assert_config_lacks 'lifecycle' "no lifecycle tricks - remove the cause of the churn"
tm_assert_config_has 'data[[:space:]]+"external"' "the sheet list must still come from the archive script"

tm_apply
for round in 1 2 3 4; do
  tm_assert_no_changes
done

IDX=atlas/index.md
tm_assert_file "$IDX" "atlas/index.md was not written"
STAMP=$(grep '^Generated: ' "$IDX" | head -n1 | sed 's/^Generated: //')
[[ "$STAMP" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]] \
  || tm_fail "the Generated line is not an RFC 3339 UTC timestamp: '$STAMP'"
grep '^- ' "$IDX" >"$TM_TMP/sheets.txt"
[[ "$(wc -l <"$TM_TMP/sheets.txt" | tr -d ' ')" == "5" ]] || tm_fail "the index should list five sheets"
sort -c "$TM_TMP/sheets.txt" 2>/dev/null || tm_fail "the sheets must be listed alphabetically"
tm_assert_output sheet_count 5

# the stamp must survive another round of plan + apply
tm_apply
[[ "$(grep '^Generated: ' "$IDX" | head -n1 | sed 's/^Generated: //')" == "$STAMP" ]] \
  || tm_fail "the Generated timestamp changed on re-apply"
tm_pass "plans are stable and the index is deterministic"
