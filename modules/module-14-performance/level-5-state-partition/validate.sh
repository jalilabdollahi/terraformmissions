#!/usr/bin/env bash
source "$TM_LIB"

PET=$(tm_recall pet); GATES=$(tm_recall gates); ROSTER=$(tm_recall roster)
[[ -n "$PET" && -n "$GATES" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

# Configuration shape
[[ -d core ]] || tm_fail "there is no core/ directory"
grep -qE 'resource[[:space:]]+"random_pet"[[:space:]]+"yard_name"' core/*.tf 2>/dev/null \
  || tm_fail "core/ must declare random_pet.yard_name"
grep -qE 'resource[[:space:]]+"random_integer"[[:space:]]+"gate_count"' core/*.tf 2>/dev/null \
  || tm_fail "core/ must declare random_integer.gate_count"
if grep -qE 'resource[[:space:]]+"random_(pet|integer)"' ./*.tf 2>/dev/null; then
  tm_fail "the root configuration must no longer declare the yard identity resources"
fi
grep -qE 'data[[:space:]]+"terraform_remote_state"' ./*.tf 2>/dev/null \
  || tm_fail "the root configuration must read core through a terraform_remote_state data source"
grep -qE 'resource[[:space:]]+"local_file"[[:space:]]+"crane_roster"' ./*.tf 2>/dev/null \
  || tm_fail "local_file.crane_roster has to stay in the root configuration"

# Root state must have let go of the identity, and kept the roster.
tm_assert_in_state local_file.crane_roster "the crane roster disappeared from the root state"
tm_assert_not_in_state random_pet.yard_name "random_pet.yard_name is still in the root state"
tm_assert_not_in_state random_integer.gate_count "random_integer.gate_count is still in the root state"

# Core state must hold the very same objects.
[[ -f core/terraform.tfstate ]] || tm_fail "core/terraform.tfstate does not exist"
core_list=$(terraform -chdir=core state list 2>/dev/null)
grep -qxF random_pet.yard_name <<<"$core_list" || tm_fail "core state does not contain random_pet.yard_name"
grep -qxF random_integer.gate_count <<<"$core_list" || tm_fail "core state does not contain random_integer.gate_count"
core_pet=$(terraform -chdir=core show -json 2>/dev/null | jq -r '[.values.root_module.resources[] | select(.address=="random_pet.yard_name")][0].values.id')
[[ "$core_pet" == "$PET" ]] || tm_fail "the yard name changed ('$PET' -> '$core_pet'); the objects must be moved, not recreated"
core_gates=$(terraform -chdir=core show -json 2>/dev/null | jq -r '[.values.root_module.resources[] | select(.address=="random_integer.gate_count")][0].values.result')
[[ "$core_gates" == "$GATES" ]] || tm_fail "the gate count changed ($GATES -> $core_gates)"

# core exposes the contract and plans clean.
terraform -chdir=core init -input=false -no-color >"$TM_LAST_OUT" 2>&1 || { tm_show_last; tm_fail "terraform init failed in core/"; }
code=$(terraform -chdir=core plan -detailed-exitcode -input=false -no-color >"$TM_LAST_OUT" 2>&1; echo $?)
[[ "$code" == "0" ]] || { tm_show_last; tm_fail "core/ does not plan clean (exit $code); did its outputs get applied?"; }
[[ "$(terraform -chdir=core output -raw yard_name 2>/dev/null)" == "$PET" ]] \
  || tm_fail "core output yard_name is missing or wrong"
[[ "$(terraform -chdir=core output -raw gate_count 2>/dev/null)" == "$GATES" ]] \
  || tm_fail "core output gate_count is missing or wrong"

tm_assert_no_changes
tm_assert_file_contains cranes/roster.txt "$PET runs $GATES gates" "the roster no longer shows the original yard identity"
tm_pass "yard '$PET' with $GATES gates lives in core/, and the roster reads it through remote state"
