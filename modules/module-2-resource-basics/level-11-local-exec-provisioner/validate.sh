#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'provisioner "local-exec"' "the stamp must still be written by a local-exec provisioner"
tm_assert_config_has 'RELEASE[[:space:]]*=[[:space:]]*var\.release' "keep feeding the release through the environment from var.release"
tm_apply
tm_assert_file_equals dist/RELEASE "release=2024.3-rc1
"
tm_assert_no_file dist/dist "the stamp was written into a nested dist/dist directory"
tm_assert_in_state null_resource.stamp_release
# a different release value must produce a different stamp (not a hard-coded string)
rm -f dist/RELEASE
tm_apply -replace=null_resource.stamp_release -var 'release=2025.1'
tm_assert_file_equals dist/RELEASE "release=2025.1
" "the stamp does not follow var.release"
tm_apply -replace=null_resource.stamp_release
tm_assert_file_equals dist/RELEASE "release=2024.3-rc1
"
tm_assert_no_changes
tm_pass "local-exec writes dist/RELEASE from var.release"
