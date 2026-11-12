#!/usr/bin/env bash
source "$TM_LIB"

# 1. No crutches anywhere in the player's files.
if grep -rqiE 'parallelism' --include='*' --exclude-dir=.terraform --exclude-dir=.tm \
     --exclude='*.tfstate*' --exclude='*.tfplan' --exclude='.terraform.lock.hcl' . 2>/dev/null; then
  tm_fail "a -parallelism setting is still present in the workspace — it hides the ordering bug instead of fixing it"
fi
tm_assert_config_lacks '(sleep|until|while)[[:space:]]' \
  "the slip command must not wait or poll — express the ordering as a dependency"
tm_assert_config_has 'resource "terraform_data" "label_slip"' "the label_slip resource has to stay"
tm_assert_config_has 'cat[[:space:]].*syrup-ledger|cat[[:space:]].*syrup_ledger' \
  "the slip must still be copied from the syrup ledger"

tm_init
tm_validate

# 2. The graph must contain a real edge slip -> ledger.
graph=$(terraform graph 2>/dev/null)
grep -Eq '"terraform_data.label_slip" -> "local_file.syrup_ledger"' <<<"$graph" \
  || tm_fail "terraform graph shows no dependency edge from terraform_data.label_slip to local_file.syrup_ledger"

# 3. Run the full apply several times from scratch: default parallelism, then the deploy script.
for round in 1 2 3; do
  terraform destroy -auto-approve -input=false -no-color >"$TM_LAST_OUT" 2>&1 \
    || { tm_show_last; tm_fail "round $round: terraform destroy failed"; }
  rm -f workshop/label-slip.txt workshop/syrup-ledger.txt
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
  [[ -f workshop/label-slip.txt ]] || tm_fail "round $round: workshop/label-slip.txt was not produced"
  grep -q '70% sugar, 20% glucose, 10% water' workshop/label-slip.txt \
    || tm_fail "round $round: the label slip does not contain the ledger text"
done

tm_assert_no_changes
tm_pass "three clean parallel applies from scratch; the slip waits for the ledger by dependency"
