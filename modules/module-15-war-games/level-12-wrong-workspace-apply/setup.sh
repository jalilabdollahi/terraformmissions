#!/usr/bin/env bash
source "$TM_LIB"
# Both workspaces got their seed in the previous release; the relay rollout was meant for prod only.
terraform workspace new prod >"$TM_LAST_OUT" 2>&1 || { tm_show_last; tm_fail "could not create workspace prod"; }
TM_MSG="seed apply failed in prod" tm_apply -target=random_id.region_seed
tm_record seed_prod "$(tm_state_attr random_id.region_seed hex)"

terraform workspace new staging >"$TM_LAST_OUT" 2>&1 || { tm_show_last; tm_fail "could not create workspace staging"; }
TM_MSG="seed apply failed in staging" tm_apply -target=random_id.region_seed
tm_record seed_staging "$(tm_state_attr random_id.region_seed hex)"

# The accident: the hotfix config (env pinned to prod) is applied while "staging" is selected.
TM_MSG="the accidental apply failed" tm_apply
for r in north-head south-pier harbour-mouth lighthouse; do
  tm_record "key_$r" "$(tm_state_attr "random_id.relay_key[\"$r\"]" hex)"
  tm_record "card_$r" "$(tm_state_attr "local_file.relay_card[\"$r\"]" id)"
done
# staging stays selected, exactly as the engineer left the terminal.
