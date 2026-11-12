#!/usr/bin/env bash
source "$TM_LIB"
# Each team applied its own stack: orchard first, press reads orchard, cellar (workspace "autumn") reads press.
for d in orchard press; do
  cd "$WORKSPACE/stacks/$d" || tm_fail "stack $d missing"
  tm_init "init failed in $d"
  TM_MSG="apply failed in $d" tm_apply
  tm_record "batch_$d" "$(tm_state_attr random_id.batch hex)"
  tm_record "quota_$d" "$(tm_state_attr random_integer.quota result)"
  tm_record "ledger_$d" "$(tm_state_attr local_file.ledger id)"
done
cd "$WORKSPACE/stacks/cellar" || tm_fail "stack cellar missing"
tm_init "init failed in cellar"
terraform workspace new autumn >"$TM_LAST_OUT" 2>&1 || { tm_show_last; tm_fail "workspace autumn"; }
TM_MSG="apply failed in cellar" tm_apply
tm_record batch_cellar "$(tm_state_attr random_id.batch hex)"
tm_record quota_cellar "$(tm_state_attr random_integer.quota result)"
tm_record ledger_cellar "$(tm_state_attr local_file.ledger id)"
terraform workspace select default >"$TM_LAST_OUT" 2>&1
cd "$WORKSPACE/stacks/all-in-one" || tm_fail "all-in-one missing"
tm_init "init failed in all-in-one"
