#!/usr/bin/env bash
source "$TM_LIB"

tm_validate "an identifier is still invalid, or a reference no longer matches its declaration"
tm_assert_config_has 'resource[[:space:]]+"local_file"' "keep the local_file resources"
tm_assert_config_lacks 'variable[[:space:]]+"[^"]* [^"]*"' "variable names cannot contain spaces"
tm_apply
tm_assert_file_equals shelf/label.txt $'PLA spool: signal orange\nDiameter: 1.75 mm\n'
tm_assert_file_equals shelf/tag.txt $'Reorder when below 200 g (signal orange)\n'
tm_assert_output_jq label_path 'endswith("shelf/label.txt")'
tm_assert_output_jq tag_path 'endswith("shelf/tag.txt")'
n=$(tm_state_list | grep -c '^local_file\.')
[[ "$n" == "2" ]] || tm_fail "expected two local_file resources in state, found $n"
tm_assert_no_changes
tm_pass "all identifiers are valid and references line up"
