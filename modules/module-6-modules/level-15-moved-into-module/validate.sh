#!/usr/bin/env bash
source "$TM_LIB"

HEX=$(tm_recall ticket)
FILE_ID=$(tm_recall manifest_id)
[[ -n "$HEX" && -n "$FILE_ID" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'module[[:space:]]+"shed"' "the resources must stay inside module.shed"

tm_init
TM_MSG="the plan would destroy objects that only changed address — Terraform must be told they moved" tm_assert_no_destroy
tm_apply

tm_assert_config_has 'moved[[:space:]]*\{' "record the refactor in the code with moved blocks"

tm_assert_in_state module.shed.random_id.ticket "module.shed.random_id.ticket is not in state"
tm_assert_in_state module.shed.local_file.manifest "module.shed.local_file.manifest is not in state"
tm_assert_not_in_state random_id.ticket "random_id.ticket is still tracked in the root module"
tm_assert_not_in_state local_file.manifest "local_file.manifest is still tracked in the root module"

NOW=$(tm_state_attr module.shed.random_id.ticket hex)
[[ "$NOW" == "$HEX" ]] || tm_fail "the boiler ticket changed ($HEX -> $NOW) — the engine's paperwork is now wrong"
NOW_ID=$(tm_state_attr module.shed.local_file.manifest id)
[[ "$NOW_ID" == "$FILE_ID" ]] || tm_fail "the manifest was recreated instead of moved"
tm_assert_output ticket "$HEX"
tm_assert_file_equals shed/manifest.txt "boiler ticket ${HEX}"$'\n'

tm_assert_no_changes
tm_pass "the ticket $HEX and its manifest moved into module.shed without being replaced"
