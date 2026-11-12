#!/usr/bin/env bash
source "$TM_LIB"
BATCH=$(tm_recall batch)
[[ -n "$BATCH" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "random_pet" "batch"' "the batch resource must stay in the configuration"
tm_assert_config_lacks 'keepers|BATCH|plum-[a-z]+-[a-z]+' "do not hard-code the batch name"

CUR=$(terraform workspace show 2>/dev/null)
[[ "$CUR" == "rehearsal" ]] || tm_fail "the selected workspace is '$CUR', expected rehearsal"

RF=terraform.tfstate.d/rehearsal/terraform.tfstate
[[ -s "$RF" ]] || tm_fail "the rehearsal workspace has no state"

PET=$(tm_state_attr random_pet.batch id)
[[ "$PET" == "$BATCH" ]] || tm_fail "rehearsal's batch codename is '${PET:-none}', the snapshot's is '$BATCH'"
[[ -s snapshots/jam-ledger.tfstate ]] || tm_fail "the snapshot file was removed"

tm_assert_no_changes
tm_assert_file_contains out/batch-card.txt "$BATCH" "the jar label card does not show the snapshot's batch"
tm_pass "rehearsal was seeded from the snapshot and still holds batch '$BATCH'"
