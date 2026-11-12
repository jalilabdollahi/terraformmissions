#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "random_string" "card_number"' "the card_number resource must stay"
tm_assert_config_lacks 'override_special|result[[:space:]]*=' "tune the generator's character classes; do not hard-code the number"
tm_apply
CARD=$(tm_output_raw card_number) || tm_fail "output card_number is missing"
[[ "$CARD" =~ ^[a-z0-9]{10}$ ]] || tm_fail "card number '$CARD' does not match ^[a-z0-9]{10}\$"
tm_assert_config_has 'special[[:space:]]*=[[:space:]]*false' "special characters are still enabled on the generator"
tm_assert_config_has 'upper[[:space:]]*=[[:space:]]*false' "uppercase letters are still enabled on the generator"
tm_assert_file_contains cards/new-member.txt "Card no: $CARD"
tm_assert_no_changes
tm_pass "card number '$CARD' is scanner-safe"
