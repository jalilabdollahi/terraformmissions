#!/usr/bin/env bash
source "$TM_LIB"

[[ -n "$(tm_recall seed_prod)" && -n "$(tm_recall card_summit-finish)" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"

ORIG=$(terraform workspace show 2>/dev/null)
restore_ws() { terraform workspace select "${ORIG:-default}" >/dev/null 2>&1; }
trap restore_ws EXIT

tm_assert_config_lacks 'env[[:space:]]*=[[:space:]]*"(prod|staging)"' "the environment must not be pinned to a literal in the config"
tm_assert_config_has 'terraform\.workspace' "the environment label has to follow the selected workspace"
[[ "$(jq '.posts | length' env/prod.json 2>/dev/null)" == "4" ]] || tm_fail "env/prod.json must still list the four prod posts"

check_ws() { terraform workspace select "$1" >"$TM_LAST_OUT" 2>&1 || tm_fail "workspace '$1' is missing"; }

# ---- prod must own the posts -------------------------------------------------
check_ws prod
[[ "$(tm_state_attr random_id.region_seed hex)" == "$(tm_recall seed_prod)" ]] \
  || tm_fail "the prod region seed is not the one prod had before the incident"
for r in forest-hairpin quarry-jump river-ford summit-finish; do
  tm_assert_in_state "random_id.post_key[\"$r\"]" "prod state has no key for post $r"
  [[ "$(tm_state_attr "random_id.post_key[\"$r\"]" hex)" == "$(tm_recall "key_$r")" ]] || tm_fail "post $r in prod carries a different key than the one already handed out"
  [[ "$(tm_state_attr "local_file.post_card[\"$r\"]" id)" == "$(tm_recall "card_$r")" ]] || tm_fail "the card for post $r in prod is not the one in race control"
  tm_assert_file_contains "marshals/prod/$r.card" "key $(tm_recall "key_$r")" "marshals/prod/$r.card does not carry the issued key"
done
[[ "$(tm_state_count)" == "9" ]] || tm_fail "prod state should hold the seed plus 4 keys and 4 cards (9 objects), found $(tm_state_count)"
TM_MSG="prod plan would destroy or replace marshal objects" tm_assert_no_destroy
TM_MSG="prod plan is not clean" tm_assert_no_changes

# ---- staging must be back to its own seed only -----------------------------------
check_ws staging
[[ "$(tm_state_attr random_id.region_seed hex)" == "$(tm_recall seed_staging)" ]] || tm_fail "the staging region seed changed"
STG=$(tm_state_list)
grep -q 'post_' <<<"$STG" && tm_fail "staging state still tracks prod post objects"
[[ "$(grep -c . <<<"$STG")" == "1" ]] || tm_fail "staging state should only hold its region seed"
TM_MSG="staging plan would destroy something" tm_assert_no_destroy
TM_MSG="staging plan is not clean - staging config and state disagree" tm_assert_no_changes
tm_assert_no_file marshals/staging "nothing should have been written under marshals/staging"

tm_pass "prod owns the four posts with their original keys, staging holds only its own seed, both plans are clean"
