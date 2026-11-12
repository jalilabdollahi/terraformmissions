#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource[[:space:]]+"random_password"[[:space:]]+"door_code"' "random_password.door_code must stay"
tm_assert_config_has 'resource[[:space:]]+"local_sensitive_file"[[:space:]]+"door_code_card"' "local_sensitive_file.door_code_card must stay"
tm_assert_config_has 'resource[[:space:]]+"time_offset"[[:space:]]+"next_audit"' "time_offset.next_audit must stay"
tm_assert_config_lacks 'audit_due[^\n]*=[[:space:]]*"20' "audit_due has to be computed by time_offset, not typed in"

tm_validate "terraform validate still rejects the configuration"
tm_apply
tm_assert_no_changes
tm_assert_no_changes

tm_assert_output audit_due "2026-03-31T00:00:00Z"

CARD=archive/door-code.txt
tm_assert_file "$CARD" "the door code card was not written"
CODE=$(cat "$CARD")
[[ "${#CODE}" == "18" ]] || tm_fail "the door code should be 18 characters, got ${#CODE}"
case "$CODE" in
  *[!A-Za-z0-9]*) tm_fail "the door code contains special characters ('$CODE')" ;;
esac
MODE=$(tm_file_mode "$CARD")
[[ "$MODE" == "600" ]] || tm_fail "archive/door-code.txt has mode $MODE, expected 600"
STATE_CODE=$(tm_state_attr random_password.door_code result)
[[ "$STATE_CODE" == "$CODE" ]] || tm_fail "the card does not hold the generated password"
tm_pass "door code, file mode and audit date all come from valid arguments"
