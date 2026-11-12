#!/usr/bin/env bash
source "$TM_LIB"
SECRET="demo-not-a-real-secret-847261"
export TF_VAR_alarm_code="$SECRET"

tm_validate "the configuration does not validate"
tm_apply
if grep -qF -- "$SECRET" "$TM_LAST_OUT"; then
  tm_fail "the alarm code was printed in the apply output"
fi

tm_assert_file panel/frost-alarm.txt "the frost panel file was not written"
if grep -qF -- "$SECRET" panel/frost-alarm.txt; then
  tm_fail "panel/frost-alarm.txt (visible to the whole night crew) contains the alarm code"
fi
tm_assert_file_contains panel/frost-alarm.txt "Frost alarm armed: yes"

# the plain 'terraform output' view must be redacted, but the value still has to exist
SHOWN=$(terraform output 2>&1)
if grep -qF -- "$SECRET" <<<"$SHOWN"; then tm_fail "'terraform output' prints the real alarm code"; fi
[[ "$SHOWN" == *"alarm_code = <sensitive>"* ]] || tm_fail "output alarm_code must still exist and be redacted (got: $SHOWN)"
J=$(terraform output -json 2>/dev/null)
[[ "$(jq -r '.alarm_code.sensitive' <<<"$J")" == "true" ]] || tm_fail "output alarm_code must be marked sensitive"
[[ "$(jq -r '.alarm_code.value' <<<"$J")" == "$SECRET" ]] || tm_fail "output alarm_code must still carry the real value for machine consumers"

# the one legitimate use of nonsensitive(): a derived fact that is not the secret
tm_assert_output code_length "${#SECRET}"
[[ "$(jq -r '.code_length.sensitive' <<<"$J")" == "false" ]] || tm_fail "code_length is just a number — the crew should see it without terraform output -json tricks"
tm_assert_file_contains panel/frost-alarm.txt "Code length: ${#SECRET} characters" "the panel should tell the crew the code length"

tm_plan_code >/dev/null
if grep -qF -- "$SECRET" "$TM_LAST_OUT"; then tm_fail "the code shows up in plan output"; fi
tm_assert_no_changes
tm_pass "code is redacted everywhere; only its length is public"
