#!/usr/bin/env bash
source "$TM_LIB"
WINTER=$(tm_recall winter_lineage); SUMMER=$(tm_recall summer_lineage)
[[ -n "$WINTER" && -n "$SUMMER" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'terraform\.workspace' "files must still be named from terraform.workspace"
tm_assert_config_lacks 'winter\.tfstate|backend[[:space:]]' "this mission is solved on disk, not by changing the backend"

CUR=$(terraform workspace show 2>/dev/null)
[[ "$CUR" == "winter" ]] || tm_fail "the selected workspace is '$CUR', not winter"

STRAY=$(find terraform.tfstate.d -maxdepth 1 -type f 2>/dev/null)
[[ -z "$STRAY" ]] || tm_fail "stray state file left in terraform.tfstate.d/: $STRAY"

WF=terraform.tfstate.d/winter/terraform.tfstate
[[ -s "$WF" ]] || tm_fail "$WF is missing — the local backend reads each workspace's state from <workspace>/terraform.tfstate"
GOT=$(jq -r .lineage "$WF" 2>/dev/null)
[[ "$GOT" == "$WINTER" ]] || tm_fail "winter's state file is not the original one (lineage '$GOT') — do not rebuild it, restore it"
[[ "$(jq '[.resources[]?] | length' "$WF")" == "2" ]] || tm_fail "winter's state should track both kiln logs"

SF=terraform.tfstate.d/summer/terraform.tfstate
[[ "$(jq -r .lineage "$SF" 2>/dev/null)" == "$SUMMER" ]] || tm_fail "the summer workspace's state was modified or replaced"

tm_assert_in_state local_file.kiln_log "winter's state does not contain local_file.kiln_log"
tm_assert_no_changes
tm_pass "winter's original state is back at terraform.tfstate.d/winter/terraform.tfstate, summer is intact and the plan is clean"
