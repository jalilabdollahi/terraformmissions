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

tm_assert_file_equals fair/programme.txt $'Ashby County Fair\nStalls: pies, jam, honey\nExtras: tombola, face painting\n'
tm_assert_file_equals fair/prices.txt $'honey: 6\njam: 3\npies: 4\nextra face painting: 5\nextra tombola: 2\n'
tm_assert_output stall_count 3
tm_assert_output_jq extras '. == ["tombola","face painting"]'
tm_pass "modern syntax, no warnings, same fair paperwork"
