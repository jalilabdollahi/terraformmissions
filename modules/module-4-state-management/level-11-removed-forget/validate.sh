#!/usr/bin/env bash
source "$TM_LIB"

MAP=$(tm_recall map_id); BOOK=$(tm_recall book_sha)
[[ -n "$MAP" && -n "$BOOK" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "local_file" "stall_map"' "the stall map must stay in the configuration"
tm_assert_config_lacks 'resource[[:space:]]+"local_file"[[:space:]]+"permit_book"' "the permit_book resource block must be removed from the configuration"
tm_assert_config_has 'removed[[:space:]]*\{' "write the hand-off as a removed block"
tm_assert_config_has 'from[[:space:]]*=[[:space:]]*local_file\.permit_book' "the removed block must name local_file.permit_book"
tm_assert_config_has 'destroy[[:space:]]*=[[:space:]]*false' "the removed block must say destroy = false"

tm_assert_file permits/permit-book.txt "permits/permit-book.txt was deleted — the clerk lost her working copy"
NOW=$(python3 -c 'import hashlib,sys; print(hashlib.sha1(open(sys.argv[1],"rb").read()).hexdigest())' permits/permit-book.txt)
[[ "$NOW" == "$BOOK" ]] || tm_fail "permits/permit-book.txt was rewritten — it must be left exactly as it was"

tm_assert_not_in_state local_file.permit_book "local_file.permit_book is still in state — a removed block takes effect on apply"
tm_assert_in_state local_file.stall_map "the stall map vanished from state"
[[ "$(tm_state_attr local_file.stall_map id)" == "$MAP" ]] || tm_fail "the stall map was recreated"

tm_assert_no_changes
tm_pass "the permit book left Terraform's care and stayed on disk"
