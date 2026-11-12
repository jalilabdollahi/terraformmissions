#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'file_permission' "set the modes with file_permission, not by chmod after the fact"
tm_assert_config_lacks 'permission[[:space:]]*=[[:space:]]*[0-9]' 'modes must be quoted strings like "0600", not bare numbers'
tm_assert_config_has 'resource "local_sensitive_file" "sync_token"' "the sensitive token resource must stay"
tm_apply
tm_assert_file fleet/sync.token
tm_assert_file fleet/machines.csv
[[ "$(tm_file_mode fleet/sync.token)" == "600" ]] || tm_fail "fleet/sync.token has mode $(tm_file_mode fleet/sync.token), expected 600"
[[ "$(tm_file_mode fleet/machines.csv)" == "644" ]] || tm_fail "fleet/machines.csv has mode $(tm_file_mode fleet/machines.csv), expected 644"
[[ "$(tm_file_mode fleet)" == "755" ]] || tm_fail "fleet/ has mode $(tm_file_mode fleet), expected 755"
tm_assert_file_equals fleet/sync.token "vm-tok-7f3a91c2d8"
[[ "$(tm_state_attr local_sensitive_file.sync_token file_permission)" == "0600" ]] || tm_fail "state does not record file_permission 0600 for the token"
tm_assert_no_changes
tm_pass "token is 0600, manifest is 0644, fleet/ is 0755"
