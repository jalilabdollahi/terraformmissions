#!/usr/bin/env bash
source "$TM_LIB"

# 1. No crutches anywhere in the player's files.
if grep -rqiE 'parallelism' --include='*' --exclude-dir=.terraform --exclude-dir=.tm \
     --exclude='*.tfstate*' --exclude='*.tfplan' --exclude='.terraform.lock.hcl' . 2>/dev/null; then
  tm_fail "a -parallelism setting is still present in the workspace — it hides the ordering bug instead of fixing it"
fi
tm_assert_config_lacks '(sleep|until|while)[[:space:]]' \
  "the slip command must not wait or poll — express the ordering as a dependency"
tm_assert_config_has 'resource "terraform_data" "casting_slip"' "the casting_slip resource has to stay"
tm_assert_config_has 'cat[[:space:]].*alloy-ledger|cat[[:space:]].*alloy_ledger' \
  "the slip must still be copied from the alloy ledger"

tm_init
tm_validate

# 2. The graph must contain a real edge slip -> ledger.
graph=$(terraform graph 2>/dev/null)
grep -Eq '"terraform_data.casting_slip" -> "local_file.alloy_ledger"' <<<"$graph" \
  || tm_fail "terraform graph shows no dependency edge from terraform_data.casting_slip to local_file.alloy_ledger"

# 3. Run the full apply several times from scratch: default parallelism, then the deploy script.
for round in 1 2 3; do
  terraform destroy -auto-approve -input=false -no-color >"$TM_LAST_OUT" 2>&1 \
    || { tm_show_last; tm_fail "round $round: terraform destroy failed"; }
  rm -f foundry/casting-slip.txt foundry/alloy-ledger.txt
  if [[ $round -lt 3 ]]; then
    if ! terraform apply -auto-approve -input=false -no-color >"$TM_LAST_OUT" 2>&1; then
      tm_show_last
      tm_fail "round $round: parallel apply failed — the slip step still races the ledger"
    fi
  else
    if ! bash scripts/deploy.sh >"$TM_LAST_OUT" 2>&1; then
      tm_show_last
      tm_fail "round $round: scripts/deploy.sh failed"
    fi
  fi
  [[ -f foundry/casting-slip.txt ]] || tm_fail "round $round: foundry/casting-slip.txt was not produced"
  grep -q '78% copper, 22% tin' foundry/casting-slip.txt \
    || tm_fail "round $round: the casting slip does not contain the ledger text"
done

tm_assert_no_changes
tm_pass "three clean parallel applies from scratch; the slip waits for the ledger by dependency"
