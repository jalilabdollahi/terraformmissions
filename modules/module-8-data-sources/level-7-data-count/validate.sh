#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"local_file"[[:space:]]+"score"' "the scores must still be read with the local_file data source"
tm_assert_config_has 'count[[:space:]]*=' "the score data source should keep using count"

tm_apply
tm_assert_output total_notes 3580
tm_assert_output_jq piece_titles '. == ["Nocturne in Blue","Winter Waltz","Pied Piper Rondo"]' "piece_titles should list the three pieces in order"
tm_assert_file_contains folio/contents.txt "3. Pied Piper Rondo - 1430 notes"
tm_assert_file_contains folio/contents.txt "Total: 3580 notes"

# A different (shorter, reordered) list must be handled too.
tm_apply -var 'scores=["p04","p02"]'
tm_assert_output total_notes 1730
tm_assert_output_jq piece_titles '. == ["Last Cadenza","Winter Waltz"]' "titles did not follow the new score list"
tm_assert_file_contains folio/contents.txt "1. Last Cadenza - 780 notes"
tm_pass "the contents page is built from every score instance, in list order"
