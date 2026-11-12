#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_lacks 'timestamp[[:space:]]*\(' "timestamp() changes on every run — it cannot be the rotation trigger"
tm_assert_config_lacks 'uuid[[:space:]]*\(' "uuid() changes on every run — it cannot be the rotation trigger"
tm_validate "the configuration does not validate"

pw() { tm_state_attr random_password.locker result; }
filepw() { tr -d '\n' < rigging/locker-code.txt; }

# 1. normal operation: the combination is generated once and then stable
tm_apply
P1=$(pw)
[[ -n "$P1" ]] || tm_fail "random_password.locker is not in state"
[[ "$(filepw)" == "$P1" ]] || tm_fail "rigging/locker-code.txt does not hold the generated combination"
tm_assert_no_changes
tm_assert_no_changes
tm_apply
[[ "$(pw)" == "$P1" ]] || tm_fail "the combination rotated although nobody raised a ticket — something changes on every run"

# 2. a new ticket must rotate it
tm_apply -var rotation_ticket=RIG-101
P2=$(pw)
[[ "$P2" != "$P1" ]] || tm_fail "raising rotation_ticket to RIG-101 did not rotate the combination"
[[ "$(filepw)" == "$P2" ]] || tm_fail "the locker file was not updated after rotation"
tm_assert_output rotation_ticket_in_force RIG-101 2>/dev/null

# 3. and then it must settle again
tm_assert_no_changes -var rotation_ticket=RIG-101
tm_apply -var rotation_ticket=RIG-101
[[ "$(pw)" == "$P2" ]] || tm_fail "the combination rotated again with the same ticket"
[[ "$(tm_file_mode rigging/locker-code.txt)" == "600" ]] || tm_fail "rigging/locker-code.txt must stay mode 0600"
tm_pass "the combination only rotates when rotation_ticket changes"
