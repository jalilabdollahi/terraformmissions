#!/usr/bin/env bash
source "$TM_LIB"

SERIAL=$(tm_recall serial)
LINEAGE=$(tm_recall lineage)
[[ -n "$SERIAL" && -n "$LINEAGE" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "random_id" "lot_seal"' "the lot seal resource was removed from the configuration"
tm_assert_config_has 'resource "terraform_data" "lot_catalogue"' "the lot catalogue resource was removed from the configuration"

NOW_LINEAGE=$(terraform state pull | jq -r .lineage)
NOW_SERIAL=$(terraform state pull | jq -r .serial)
[[ "$NOW_LINEAGE" == "$LINEAGE" ]] || tm_fail "the state's lineage changed — this is no longer the state the authentication desk asked about"
[[ "$NOW_SERIAL" == "$SERIAL" ]] || tm_fail "the state was modified (serial $SERIAL → $NOW_SERIAL); this mission only reads the state"

for f in serial lineage seal-hex; do
  tm_assert_file "answers/$f.txt" "answers/$f.txt does not exist yet"
done
GOT_SERIAL=$(tr -d '[:space:]' < answers/serial.txt)
GOT_LINEAGE=$(tr -d '[:space:]"' < answers/lineage.txt)
GOT_SEAL=$(tr -d '[:space:]"' < answers/seal-hex.txt)
SEAL=$(tm_state_attr random_id.lot_seal hex)

[[ "$GOT_SERIAL" == "$SERIAL" ]] || tm_fail "answers/serial.txt holds '$GOT_SERIAL' — that is not the state's serial"
[[ "$GOT_LINEAGE" == "$LINEAGE" ]] || tm_fail "answers/lineage.txt holds '$GOT_LINEAGE' — that is not the state's lineage"
[[ "$GOT_SEAL" == "$SEAL" ]] || tm_fail "answers/seal-hex.txt holds '$GOT_SEAL' — that is not the hex of random_id.lot_seal"

tm_assert_no_changes
tm_pass "serial $SERIAL, lineage $LINEAGE and seal $SEAL are filed with the authentication desk"
