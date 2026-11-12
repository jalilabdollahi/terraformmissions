#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"local_file"[[:space:]]+"galley"' "the galleys must still be read with the local_file data source"
tm_assert_config_has 'count[[:space:]]*=' "the galley data source should keep using count"

tm_apply
tm_assert_output total_words 3580
tm_assert_output_jq chapter_titles '. == ["The Ink Merchant","A Press in Winter","Pied Type"]' "chapter_titles should list the three chapters in order"
tm_assert_file_contains proofs/contents.txt "3. Pied Type - 1430 words"
tm_assert_file_contains proofs/contents.txt "Total: 3580 words"

# A different (shorter, reordered) list must be handled too.
tm_apply -var 'galleys=["ch04","ch02"]'
tm_assert_output total_words 1730
tm_assert_output_jq chapter_titles '. == ["Last Proof","A Press in Winter"]' "titles did not follow the new galley list"
tm_assert_file_contains proofs/contents.txt "1. Last Proof - 780 words"
tm_pass "the contents page is built from every galley instance, in list order"
