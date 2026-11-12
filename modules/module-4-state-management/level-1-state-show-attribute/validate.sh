#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "random_integer" "serial"' "the vault resources were removed from the configuration"
tm_assert_config_has 'resource "random_pet" "night_guard"' "the night guard resource was removed from the configuration"

[[ $(tm_state_count) -ge 4 ]] || tm_fail "the state no longer holds all the registry objects — the audit needs the originals"

SERIAL=$(tm_state_attr 'random_integer.serial["annex"]' result)
GUARD=$(tm_state_attr random_pet.night_guard id)
[[ -n "$SERIAL" && -n "$GUARD" ]] || tm_fail "could not read the vault objects from state — run 'reset' to restore the level"

tm_assert_file answers/vault-serial.txt "answers/vault-serial.txt does not exist yet"
tm_assert_file answers/night-guard.txt "answers/night-guard.txt does not exist yet"

GOT_SERIAL=$(tr -d '[:space:]' < answers/vault-serial.txt)
GOT_GUARD=$(tr -d '[:space:]' < answers/night-guard.txt)

[[ "$GOT_SERIAL" == "$SERIAL" ]] || tm_fail "answers/vault-serial.txt holds '$GOT_SERIAL' — that is not the annex vault's serial"
[[ "$GOT_GUARD" == "$GUARD" ]] || tm_fail "answers/night-guard.txt holds '$GOT_GUARD' — that is not the night guard's codename"

tm_assert_no_changes
tm_pass "the auditor has the annex serial ($SERIAL) and the guard codename ($GUARD), and nothing was changed"
