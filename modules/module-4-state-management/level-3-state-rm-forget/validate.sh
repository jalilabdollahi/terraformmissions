#!/usr/bin/env bash
source "$TM_LIB"

LOG_ID=$(tm_recall log_id)
REG_SHA=$(tm_recall registry_sha)
[[ -n "$LOG_ID" && -n "$REG_SHA" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "local_file" "inspection_log"' "the inspection log must stay in the configuration"
tm_assert_config_lacks 'resource[[:space:]]+"local_file"[[:space:]]+"queen_registry"' \
  "the queen_registry block is still in the configuration — we no longer manage it"
tm_assert_config_lacks 'removed[[:space:]]*\{' "this mission uses the state CLI, not a removed block"

tm_assert_file records/queen-registry.txt "records/queen-registry.txt is gone — the association's only copy was deleted"
NOW=$(python3 -c 'import hashlib,sys; print(hashlib.sha1(open(sys.argv[1],"rb").read()).hexdigest())' records/queen-registry.txt)
[[ "$NOW" == "$REG_SHA" ]] || tm_fail "records/queen-registry.txt was changed or recreated — it must be left exactly as it was"

tm_assert_not_in_state local_file.queen_registry "local_file.queen_registry is still managed in state"
tm_assert_in_state local_file.inspection_log "local_file.inspection_log vanished from state"
[[ "$(tm_state_attr local_file.inspection_log id)" == "$LOG_ID" ]] || tm_fail "the inspection log was replaced"

tm_assert_no_changes
tm_pass "the queen registry is on disk, out of state and out of code; the rest of the apiary is untouched"
