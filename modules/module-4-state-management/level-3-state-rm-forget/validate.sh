#!/usr/bin/env bash
source "$TM_LIB"

LOG_ID=$(tm_recall log_id)
REG_SHA=$(tm_recall book_sha)
[[ -n "$LOG_ID" && -n "$REG_SHA" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "local_file" "vet_log"' "the vet log must stay in the configuration"
tm_assert_config_lacks 'resource[[:space:]]+"local_file"[[:space:]]+"stud_book"' \
  "the stud_book block is still in the configuration — we no longer manage it"
tm_assert_config_lacks 'removed[[:space:]]*\{' "this mission uses the state CLI, not a removed block"

tm_assert_file records/stud-book.txt "records/stud-book.txt is gone — the association's only copy was deleted"
NOW=$(python3 -c 'import hashlib,sys; print(hashlib.sha1(open(sys.argv[1],"rb").read()).hexdigest())' records/stud-book.txt)
[[ "$NOW" == "$REG_SHA" ]] || tm_fail "records/stud-book.txt was changed or recreated — it must be left exactly as it was"

tm_assert_not_in_state local_file.stud_book "local_file.stud_book is still managed in state"
tm_assert_in_state local_file.vet_log "local_file.vet_log vanished from state"
[[ "$(tm_state_attr local_file.vet_log id)" == "$LOG_ID" ]] || tm_fail "the vet log was replaced"

tm_assert_no_changes
tm_pass "the stud book is on disk, out of state and out of code; the rest of the stud is untouched"
