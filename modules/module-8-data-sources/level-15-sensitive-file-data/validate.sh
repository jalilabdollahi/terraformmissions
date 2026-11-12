#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"local_sensitive_file"' "read the combination with the data source made for secrets"
tm_assert_config_lacks 'nonsensitive[[:space:]]*\(' "nonsensitive() would just re-expose the secret"

tm_apply
if grep -q '7-31-4-19' "$TM_LAST_OUT"; then
  tm_fail "the combination is printed in plain text in the apply log"
fi
tm_assert_output_jq combination '. == "7-31-4-19"' "terraform output must still return the real combination when asked"
[[ "$(terraform output -json 2>/dev/null | jq -r '.combination.sensitive')" == "true" ]] \
  || tm_fail "the combination output is not marked sensitive"
tm_assert_file_contains tillroom/door-card.txt "safe combination: 7-31-4-19"
[[ "$(tm_file_mode tillroom/door-card.txt)" == "600" ]] || tm_fail "tillroom/door-card.txt must be readable by its owner only (0600), it is $(tm_file_mode tillroom/door-card.txt)"

# New combination: the plan must not display it either, and the card must follow.
cp tillroom/combination.txt "$TM_TMP/combo.orig"
trap 'cp "$TM_TMP/combo.orig" tillroom/combination.txt' EXIT
printf '12-5-40-8\n' > tillroom/combination.txt
code=$(tm_plan_code)
[[ "$code" == "2" ]] || tm_fail "changing the combination should show up in the plan"
if grep -q '12-5-40-8' "$TM_LAST_OUT"; then
  tm_fail "the new combination is printed in plain text in the plan"
fi
tm_apply
tm_assert_output combination "12-5-40-8"
tm_assert_file_contains tillroom/door-card.txt "safe combination: 12-5-40-8" "the door card did not follow the edited combination file"
[[ "$(tm_file_mode tillroom/door-card.txt)" == "600" ]] || tm_fail "tillroom/door-card.txt lost its 0600 mode"
tm_pass "the combination is read as a secret, masked in logs and outputs, and the card is private"
