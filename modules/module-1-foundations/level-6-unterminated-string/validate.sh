#!/usr/bin/env bash
source "$TM_LIB"

tm_validate "the configuration still has a string problem — check where each quoted string begins and ends"
tm_apply
tm_assert_file_equals placards/gallery-4.txt $'Gallery 4: Impressionists, 1870-1890\nCurated by Ines Calloway\n'
tm_assert_file_equals placards/gallery-7.txt $'Gallery 7: Ceramics\nAsk a guide about the Ming vase.\n'
tm_assert_output_jq placards 'length == 2'
# the curator must still come from the variable
tm_apply -var 'curator=Tomasz Wren'
tm_assert_file_contains placards/gallery-4.txt "Curated by Tomasz Wren" "gallery-4 should still use var.curator"
tm_apply
tm_assert_no_changes
tm_pass "both placards are written with the exact text"
