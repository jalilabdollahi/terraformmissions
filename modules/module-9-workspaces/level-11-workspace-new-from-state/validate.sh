#!/usr/bin/env bash
source "$TM_LIB"
BLEND=$(tm_recall blend)
[[ -n "$BLEND" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "random_pet" "blend"' "the blend resource must stay in the configuration"
tm_assert_config_lacks 'keepers|BLEND|chai-[a-z]+-[a-z]+' "do not hard-code the blend name"

CUR=$(terraform workspace show 2>/dev/null)
[[ "$CUR" == "rehearsal" ]] || tm_fail "the selected workspace is '$CUR', expected rehearsal"

RF=terraform.tfstate.d/rehearsal/terraform.tfstate
[[ -s "$RF" ]] || tm_fail "the rehearsal workspace has no state"

PET=$(tm_state_attr random_pet.blend id)
[[ "$PET" == "$BLEND" ]] || tm_fail "rehearsal's blend codename is '${PET:-none}', the snapshot's is '$BLEND'"
[[ -s snapshots/tea-ledger.tfstate ]] || tm_fail "the snapshot file was removed"

tm_assert_no_changes
tm_assert_file_contains out/blend-card.txt "$BLEND" "the shelf card does not show the snapshot's blend"
tm_pass "rehearsal was seeded from the snapshot and still holds blend '$BLEND'"
