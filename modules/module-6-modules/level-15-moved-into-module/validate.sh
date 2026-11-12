#!/usr/bin/env bash
source "$TM_LIB"

HEX=$(tm_recall ticket)
FILE_ID=$(tm_recall manifest_id)
[[ -n "$HEX" && -n "$FILE_ID" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'module[[:space:]]+"hangar"' "the resources must stay inside module.hangar"

tm_init
TM_MSG="the plan would destroy objects that only changed address — Terraform must be told they moved" tm_assert_no_destroy
tm_apply

tm_assert_config_has 'moved[[:space:]]*\{' "record the refactor in the code with moved blocks"

tm_assert_in_state module.hangar.random_id.ticket "module.hangar.random_id.ticket is not in state"
tm_assert_in_state module.hangar.local_file.manifest "module.hangar.local_file.manifest is not in state"
tm_assert_not_in_state random_id.ticket "random_id.ticket is still tracked in the root module"
tm_assert_not_in_state local_file.manifest "local_file.manifest is still tracked in the root module"

NOW=$(tm_state_attr module.hangar.random_id.ticket hex)
[[ "$NOW" == "$HEX" ]] || tm_fail "the mooring ticket changed ($HEX -> $NOW) — the airship's paperwork is now wrong"
NOW_ID=$(tm_state_attr module.hangar.local_file.manifest id)
[[ "$NOW_ID" == "$FILE_ID" ]] || tm_fail "the manifest was recreated instead of moved"
tm_assert_output ticket "$HEX"
tm_assert_file_equals hangar/manifest.txt "mooring ticket ${HEX}"$'\n'

tm_assert_no_changes
tm_pass "the ticket $HEX and its manifest moved into module.hangar without being replaced"
