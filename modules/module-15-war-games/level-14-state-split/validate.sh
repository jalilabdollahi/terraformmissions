#!/usr/bin/env bash
source "$TM_LIB"

[[ -n "$(tm_recall dock_key)" && -n "$(tm_recall cue_sheet)" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"

tm_assert_config_has 'terraform_remote_state' "the stacks must share values through terraform_remote_state"
for k in dock_key capacity light_key signup; do
  tm_assert_config_lacks "$(tm_recall $k)" "an identifier is typed into the code - values must flow through state"
done
if ls monolith/*.tf >/dev/null 2>&1; then
  grep -qE '^[[:space:]]*(resource|data|module)[[:space:]]' monolith/*.tf && tm_fail "monolith/ still contains resource code - it must be emptied"
fi
if [[ -f monolith/terraform.tfstate ]]; then
  [[ "$(jq '.resources | length' monolith/terraform.tfstate)" == "0" ]] || tm_fail "monolith/terraform.tfstate still tracks objects - every object must live in exactly one new stack"
fi

managed_count() { local l; l=$(tm_state_list); grep -vc "^data\\." <<<"$l"; }
stack() { cd "$WORKSPACE/$1" 2>/dev/null || tm_fail "stack $1/ is missing"; tm_init "init failed in $1/"; }
want() { # <stack> <address> <attribute> <recall key> <what>
  tm_assert_in_state "$2" "$5 is not in the $1 state"
  [[ "$(tm_state_attr "$2" "$3")" == "$(tm_recall "$4")" ]] || tm_fail "$5 in $1 was re-issued: its value is not the float warehouse's original"
}

stack warehouse
want warehouse random_id.dock_key hex dock_key "the dock key"
want warehouse random_integer.rider_capacity result capacity "the rider capacity"
want warehouse 'random_id.float_serial["main"]' hex float_main "the main float serial"
want warehouse 'random_id.float_serial["annex"]' hex float_annex "the annex float serial"
[[ "$(managed_count)" == "4" ]] || tm_fail "warehouse should hold exactly 4 objects, found $(managed_count)"
tm_assert_no_destroy
TM_MSG="warehouse plan is not clean (are its outputs published?)" tm_assert_no_changes

stack krewes
want krewes random_uuid.signup_ns result signup "the sign-up namespace"
want krewes 'random_integer.bead_series["gold"]' result gold "the gold bead series"
want krewes 'random_integer.bead_series["silver"]' result silver "the silver bead series"
want krewes local_file.bead_ledger id bead_ledger "the bead ledger"
[[ "$(managed_count)" == "4" ]] || tm_fail "krewes should hold exactly 4 objects, found $(managed_count)"
tm_assert_no_destroy
TM_MSG="krewes plan is not clean" tm_assert_no_changes

stack lighting
want lighting random_id.light_key hex light_key "the lights key"
want lighting 'terraform_data.controller["a"]' id enc_a "controller a"
want lighting 'terraform_data.controller["b"]' id enc_b "controller b"
want lighting local_file.cue_sheet id cue_sheet "the cue_sheet"
tm_assert_not_in_state random_id.rig_key "random_id.rig_key should have been renamed to light_key"
tm_assert_no_destroy
TM_MSG="lighting plan is not clean" tm_assert_no_changes

cd "$WORKSPACE" || exit 1
tm_assert_file_contains out/bead-ledger.txt "dock $(tm_recall dock_key)" "the bead ledger changed"
tm_assert_file_contains out/cue_sheet.txt "gold $(tm_recall gold)" "the cue_sheet changed"
tm_pass "three stacks own their objects with original identities, monolith is empty, all plans clean"
