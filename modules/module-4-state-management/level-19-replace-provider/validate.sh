#!/usr/bin/env bash
source "$TM_LIB"

TAG=$(tm_recall tag); PALLETS=$(tm_recall pallets)
[[ -n "$TAG" && -n "$PALLETS" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'source[[:space:]]*=[[:space:]]*"hashicorp/random"' "the required_providers entry for hashicorp/random was changed"

terraform state pull >"$TM_TMP/state.json" 2>"$TM_LAST_OUT" || { tm_show_last; tm_fail "Terraform cannot read the state yet"; }
if jq -e '.resources[] | select(.provider | contains("/-/"))' "$TM_TMP/state.json" >/dev/null 2>&1; then
  LEGACY=$(jq -r '[.resources[] | select(.provider | contains("/-/")) | .provider] | unique | join(", ")' "$TM_TMP/state.json")
  tm_fail "the state still references a legacy provider address: $LEGACY"
fi
BAD=$(jq -r '[.resources[] | select(.type | startswith("random_")) | select(.provider != "provider[\"registry.terraform.io/hashicorp/random\"]")] | length' "$TM_TMP/state.json")
[[ "$BAD" == "0" ]] || tm_fail "$BAD random_* resource(s) in state point at a provider other than registry.terraform.io/hashicorp/random"

tm_init "terraform init still fails"
tm_assert_in_state random_id.crate_tag "the crate tag is missing from state"
[[ "$(tm_state_attr random_id.crate_tag hex)" == "$TAG" ]] || tm_fail "the crate tag changed — the state was rebuilt instead of repaired"
[[ "$(tm_state_attr random_integer.pallet_count result)" == "$PALLETS" ]] || tm_fail "the pallet count changed"

tm_assert_no_changes
tm_assert_file_contains labels/crate.txt "$TAG" "the crate label does not show the original tag"
tm_pass "state repaired: crate $TAG, $PALLETS pallets, provider address hashicorp/random"
