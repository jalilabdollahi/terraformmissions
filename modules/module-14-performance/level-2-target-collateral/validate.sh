#!/usr/bin/env bash
source "$TM_LIB"

SEAL=$(tm_recall seal)
[[ -n "$SEAL" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

for r in random_id.rack_seal local_file.costume_register local_file.fitting_roster terraform_data.dry_clean_notice; do
  tm_assert_in_state "$r" "$r is not in state — the wardrobe is still incomplete"
done

[[ "$(tm_state_attr random_id.rack_seal hex)" == "$SEAL" ]] \
  || tm_fail "the rack seal changed — it was printed on the garment tags and must be kept"

tm_assert_file wardrobe/register.txt "wardrobe/register.txt is missing"
tm_assert_file wardrobe/fitting-roster.txt "wardrobe/fitting-roster.txt is missing"
tm_assert_file_contains wardrobe/register.txt "$SEAL" "the register does not quote the original rack seal"

tm_assert_file wardrobe/notices.log "wardrobe/notices.log is missing"
lines=$(grep -c . wardrobe/notices.log)
[[ "$lines" == "2" ]] \
  || tm_fail "the laundry notice has fired $lines time(s); it should be 2 (original run + exactly one recovery)"

tm_assert_no_changes
tm_pass "the full set is back, the seal $SEAL survived, and the laundry was notified exactly once more"
