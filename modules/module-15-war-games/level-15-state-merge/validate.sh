#!/usr/bin/env bash
source "$TM_LIB"

[[ -n "$(tm_recall batch_orchard)" && -n "$(tm_recall ledger_cellar)" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"

tm_assert_config_has 'module[[:space:]]+"orchard"' "the merged stack must keep one module call per team"
tm_assert_config_has 'module[[:space:]]+"press"' "the merged stack must keep one module call per team"
tm_assert_config_has 'module[[:space:]]+"cellar"' "the merged stack must keep one module call per team"
for t in orchard press cellar; do
  tm_assert_config_lacks "$(tm_recall "batch_$t")" "a batch id is typed into the configuration"
  if ls stacks/$t/*.tf >/dev/null 2>&1 && grep -qE '^[[:space:]]*resource[[:space:]]' stacks/$t/*.tf; then
    tm_fail "stacks/$t still has resource code - retire the old team stacks once their objects are merged"
  fi
done

# Every old state file (including workspaces) must be empty: one owner per object.
for f in stacks/orchard stacks/press stacks/cellar; do
  while IFS= read -r sf; do
    [[ -z "$sf" ]] && continue
    [[ "$(jq '[.resources[] | select(.mode == "managed")] | length' "$sf")" == "0" ]] || tm_fail "$sf still tracks objects - they belong in stacks/all-in-one now"
  done < <(find "$f" -name '*.tfstate' -not -path '*/.terraform/*' 2>/dev/null)
done

cd "$WORKSPACE/stacks/all-in-one" || tm_fail "stacks/all-in-one is missing"
tm_init "init failed in stacks/all-in-one"
for t in orchard press cellar; do
  for r in random_id.batch random_integer.quota local_file.ledger; do
    tm_assert_in_state "module.$t.$r" "module.$t.$r is not in the merged state"
  done
  [[ "$(tm_state_attr "module.$t.random_id.batch" hex)" == "$(tm_recall "batch_$t")" ]] || tm_fail "the $t batch id is not the one the $t team created"
  [[ "$(tm_state_attr "module.$t.random_integer.quota" result)" == "$(tm_recall "quota_$t")" ]] || tm_fail "the $t quota was re-rolled"
  [[ "$(tm_state_attr "module.$t.local_file.ledger" id)" == "$(tm_recall "ledger_$t")" ]] || tm_fail "the $t ledger file was rewritten"
done
STATE=$(tm_state_list)
[[ "$(grep -c . <<<"$STATE")" == "9" ]] || tm_fail "merged state should hold exactly 9 objects (3 per team), found $(grep -c . <<<"$STATE")"
TM_MSG="the merged plan would replace objects - the merged config does not describe them as they exist" tm_assert_no_destroy
tm_assert_no_changes
cd "$WORKSPACE" || exit 1
tm_assert_file_contains out/press-ledger.txt "upstream $(tm_recall batch_orchard)" "the press ledger lost its link to the orchard batch"
tm_assert_file_contains out/cellar-ledger.txt "upstream $(tm_recall batch_press)" "the cellar ledger lost its link to the press batch"
tm_pass "three team states merged into one with every batch, quota and ledger intact"
