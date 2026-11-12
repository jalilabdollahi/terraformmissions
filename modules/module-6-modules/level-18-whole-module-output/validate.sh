#!/usr/bin/env bash
source "$TM_LIB"

tm_init
TM_MSG="terraform apply failed — what type does each argument expect and what is module.stall?" tm_apply

tm_assert_in_state local_file.board
tm_assert_output_jq fields '. == ["catch","owner","pitch"]' "fields must be [catch, owner, pitch]"
jq -e '. == {"owner":"Brita Hallgren","pitch":43,"catch":["herring","mackerel","pike-perch"]}' board/stall.json >/dev/null 2>&1 \
  || { cat board/stall.json 2>/dev/null | sed 's/^/   │ /'; tm_fail "board/stall.json does not hold the module's outputs as JSON"; }

# A different stall: the record has to follow the module, not a snapshot
tm_apply -var owner="Ole Brandt" -var 'catch=["cod","haddock"]'
jq -e '. == {"owner":"Ole Brandt","pitch":42,"catch":["cod","haddock"]}' board/stall.json >/dev/null 2>&1 \
  || tm_fail "board/stall.json did not follow the module's new outputs"

tm_apply
tm_assert_no_changes
tm_assert_config_has 'jsonencode\(module\.stall\)' "the board must be built from the whole module.stall object"
tm_assert_config_has 'keys\(module\.stall\)' "the field list must be derived from module.stall, not typed out"
tm_pass "module.stall is used as a whole: its JSON on the board, its keys as the field list"
