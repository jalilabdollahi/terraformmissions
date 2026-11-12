#!/usr/bin/env bash
source "$TM_LIB"

tm_init
TM_MSG="terraform apply failed — what type does each argument expect and what is module.busker?" tm_apply

tm_assert_in_state local_file.board
tm_assert_output_jq fields '. == ["performer","setlist","slot"]' "fields must be [performer, setlist, slot]"
jq -e '. == {"performer":"Marta Vik","slot":43,"setlist":["ballad","jig","waltz"]}' board/busker.json >/dev/null 2>&1 \
  || { cat board/busker.json 2>/dev/null | sed 's/^/   │ /'; tm_fail "board/busker.json does not hold the module's outputs as JSON"; }

# A different busker: the record has to follow the module, not a snapshot
tm_apply -var performer="Jonas Lund" -var 'setlist=["polka","reel"]'
jq -e '. == {"performer":"Jonas Lund","slot":42,"setlist":["polka","reel"]}' board/busker.json >/dev/null 2>&1 \
  || tm_fail "board/busker.json did not follow the module's new outputs"

tm_apply
tm_assert_no_changes
tm_assert_config_has 'jsonencode\(module\.busker\)' "the board must be built from the whole module.busker object"
tm_assert_config_has 'keys\(module\.busker\)' "the field list must be derived from module.busker, not typed out"
tm_pass "module.busker is used as a whole: its JSON on the board, its keys as the field list"
