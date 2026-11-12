#!/usr/bin/env bash
source "$TM_LIB"

MASCOT=$(tm_recall mascot)
[[ -n "$MASCOT" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'import[[:space:]]*\{' "adopt the key with an import block"
tm_assert_config_has 'to[[:space:]]*=[[:space:]]*module\.hut\.random_id\.key' "the import target must be the key resource inside module.hut"
tm_assert_config_has '"Rk9mPg"' "the import ID is the key number from HANDOVER.md"

tm_plan_json
IMPORTING=$(jq -r '[.resource_changes[]? | select(.change.importing != null) | .address] | join(",")' "$TM_TMP/plan.json")
STATE_KEY=$(tm_state_attr module.hut.random_id.key b64_url)
if [[ -z "$STATE_KEY" && "$IMPORTING" != "module.hut.random_id.key" ]]; then
  tm_fail "the plan does not import module.hut.random_id.key (importing: ${IMPORTING:-nothing})"
fi
tm_assert_no_destroy
tm_apply

tm_assert_in_state module.hut.random_id.key
tm_assert_in_state module.hut.local_file.keyring
tm_assert_not_in_state random_id.key "a random_id.key at the root should not exist"
[[ "$(tm_state_attr module.hut.random_id.key b64_url)" == "Rk9mPg" ]] || tm_fail "the key in state is not number Rk9mPg: it was generated, not adopted"
[[ "$(tm_state_attr module.hut.random_pet.mascot id)" == "$MASCOT" ]] || tm_fail "the hut mascot was replaced"

HEX=$(tm_output_raw hut_key)
[[ "$HEX" == "$(tm_state_attr module.hut.random_id.key hex)" && ${#HEX} -eq 8 ]] || tm_fail "output hut_key does not show the adopted key"
tm_assert_file_contains huts/eagles-nest.txt "key ${HEX}"
tm_assert_no_changes
tm_pass "key Rk9mPg now lives at module.hut.random_id.key (hex ${HEX})"
