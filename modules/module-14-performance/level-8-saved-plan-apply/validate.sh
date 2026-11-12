#!/usr/bin/env bash
source "$TM_LIB"

STALE=$(tm_recall stale_plan)
[[ -n "$STALE" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource[[:space:]]+"local_file"[[:space:]]+"register"' "the register resource has to stay"
tm_assert_file plan.tfplan "plan.tfplan is missing — the apply must come from a saved plan file"

[[ "$(shasum plan.tfplan | cut -d' ' -f1)" != "$STALE" ]] \
  || tm_fail "plan.tfplan is still the stale plan from this morning; save a new one"

terraform show -json plan.tfplan >"$TM_TMP/saved.json" 2>"$TM_TMP/show.err" \
  || { cat "$TM_TMP/show.err"; tm_fail "plan.tfplan is not a readable saved plan"; }

creates=$(jq '[.resource_changes[]? | select(.type=="local_file" and (.change.actions == ["create"]))] | length' "$TM_TMP/saved.json")
[[ "$creates" -ge 1 ]] \
  || tm_fail "plan.tfplan contains no creations; save the plan before applying it, not after"

deletes=$(jq '[.resource_changes[]? | select(.change.actions | index("delete"))] | length' "$TM_TMP/saved.json")
[[ "$deletes" == "0" ]] || tm_fail "plan.tfplan contains deletions; the head arborist approved only additions"

for c in t-3011 t-3012 t-3013 t-3014 t-3015; do
  tm_assert_in_state "local_file.register[\"$c\"]" "order $c is not in state yet"
  tm_assert_file "register/$c.txt" "register/$c.txt is missing"
done

# Every creation named in the saved plan really happened.
missing=$(jq -r '.resource_changes[]? | select(.change.actions == ["create"]) | .address' "$TM_TMP/saved.json" | while read -r a; do
  s=$(tm_state_list); grep -qxF -- "$a" <<<"$s" || echo "$a"; done)
[[ -z "$missing" ]] || tm_fail "the saved plan names objects that are not in state: $missing"

tm_assert_no_changes
tm_pass "all five orders are registered from a fresh saved plan with $creates creation(s)"
