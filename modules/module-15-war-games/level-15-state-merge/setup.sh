#!/usr/bin/env bash
source "$TM_LIB"
# Each team applied its own stack: fields first, drying reads fields, packing (workspace "autumn") reads drying.
for d in fields drying; do
  cd "$WORKSPACE/stacks/$d" || tm_fail "stack $d missing"
  tm_init "init failed in $d"
  TM_MSG="apply failed in $d" tm_apply
  tm_record "batch_$d" "$(tm_state_attr random_id.batch hex)"
  tm_record "quota_$d" "$(tm_state_attr random_integer.quota result)"
  tm_record "ledger_$d" "$(tm_state_attr local_file.ledger id)"
done
cd "$WORKSPACE/stacks/packing" || tm_fail "stack packing missing"
tm_init "init failed in packing"
terraform workspace new autumn >"$TM_LAST_OUT" 2>&1 || { tm_show_last; tm_fail "workspace autumn"; }
TM_MSG="apply failed in packing" tm_apply
tm_record batch_packing "$(tm_state_attr random_id.batch hex)"
tm_record quota_packing "$(tm_state_attr random_integer.quota result)"
tm_record ledger_packing "$(tm_state_attr local_file.ledger id)"
terraform workspace select default >"$TM_LAST_OUT" 2>&1
cd "$WORKSPACE/stacks/all-in-one" || tm_fail "all-in-one missing"
tm_init "init failed in all-in-one"
