#!/usr/bin/env bash
source "$TM_LIB"

LABEL=$(tm_recall label); PIN=$(tm_recall pin); ZONE=$(tm_recall zone)
[[ -n "$LABEL" && -n "$PIN" && -n "$ZONE" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

for r in 'random_string" "bay_label' 'random_password" "airlock_pin' 'random_integer" "irrigation_zone'; do
  grep -qE "resource[[:space:]]+\"$r\"" main.tf 2>/dev/null \
    || tm_fail "main.tf has no resource \"${r/\" \"/\" \"}\" block yet"
done

# Rule 1: resource blocks live in main.tf only.
while IFS= read -r f; do
  [[ "$f" == "./main.tf" ]] && continue
  grep -qE '^[[:space:]]*resource[[:space:]]+"' "$f" && tm_fail "$f still declares resources — merge them into main.tf and delete the draft file"
done < <(find . -name '*.tf' -not -path './.terraform/*' -not -path './.tm/*')

# Rules 2 and 3: generator leftovers.
tm_assert_config_lacks '=[[:space:]]*null([[:space:]]|$)' "an attribute is still set to null — remove those lines"
tm_assert_config_lacks '__generated__' "generator marker comments are still in the configuration"

tm_assert_in_state random_string.bay_label "random_string.bay_label is not in state — run apply to perform the imports"
tm_assert_in_state random_password.airlock_pin "random_password.airlock_pin is not in state — run apply to perform the imports"
tm_assert_in_state random_integer.irrigation_zone "random_integer.irrigation_zone is not in state — run apply to perform the imports"

[[ "$(tm_state_attr random_string.bay_label result)" == "$LABEL" ]] || tm_fail "the bay label in state is not the live one"
[[ "$(tm_state_attr random_password.airlock_pin result)" == "$PIN" ]] || tm_fail "the airlock pin in state is not the live one"
[[ "$(tm_state_attr random_integer.irrigation_zone result)" == "$ZONE" ]] || tm_fail "the irrigation zone in state is not the live one"

tm_assert_no_changes
tm_pass "three live objects are adopted with a tidy, generated-then-cleaned configuration"
