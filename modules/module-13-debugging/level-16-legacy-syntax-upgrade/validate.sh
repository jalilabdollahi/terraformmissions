#!/usr/bin/env bash
source "$TM_LIB"

# validate must be fully clean: no errors and no deprecation warnings
if ! terraform validate -json >"$TM_TMP/validate.json" 2>/dev/null; then
  jq -r '.diagnostics[]? | "   | \(.severity): \(.summary)"' "$TM_TMP/validate.json" | sort | uniq -c | head -10
  tm_fail "terraform validate still reports errors"
fi
WARN=$(jq -r '.warning_count' "$TM_TMP/validate.json")
if [[ "$WARN" != "0" ]]; then
  jq -r '.diagnostics[]? | "   | \(.severity): \(.summary)"' "$TM_TMP/validate.json" | sort | uniq -c | head -10
  tm_fail "terraform validate reports $WARN warning(s) - the old syntax must go, not just the errors"
fi

tm_assert_config_lacks '"\$\{[^}"]*\}"' "a string that is only one interpolation (\"\${...}\") is 0.11 style - use the expression directly"
tm_assert_config_lacks '(^|[^a-z_])(list|map)\([[:space:]]*"' "list() and map() were removed - use [ ] and { } (or tolist/tomap)"
tm_assert_config_lacks 'type[[:space:]]*=[[:space:]]*"' "type constraints are no longer quoted strings"
tm_assert_config_lacks 'depends_on[[:space:]]*=[[:space:]]*\[[[:space:]]*"' "depends_on takes references, not strings"

tm_apply
tm_assert_no_changes
tm_assert_no_changes

tm_assert_file_equals con/programme.txt $'Nova City Comic Con\nStalls: posters, cards, figures\nExtras: cosplay, meet and greet\n'
tm_assert_file_equals con/prices.txt $'cards: 3\nfigures: 6\nposters: 4\nextra cosplay: 2\nextra meet and greet: 5\n'
tm_assert_output stall_count 3
tm_assert_output_jq extras '. == ["cosplay","meet and greet"]'
tm_pass "modern syntax, no warnings, same convention paperwork"
