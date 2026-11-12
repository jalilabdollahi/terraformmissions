#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'required_version[[:space:]]*=' "keep a required_version gate in terraform.tf — just make it accept modern Terraform"
tm_assert_config_lacks '<[[:space:]]*1\.0' "the gate still forbids every Terraform 1.x release"
tm_validate "terraform still refuses to run — the required_version constraint rejects the installed version"
tm_apply
tm_assert_file_equals harbour/tides.csv $'port,high,low\nSaltmarsh,06:42,12:55\nGullcove,07:10,13:20\n'
tm_assert_output tide_rows 2
tm_assert_no_changes
tm_pass "the version gate accepts this Terraform and the tide card is written"
