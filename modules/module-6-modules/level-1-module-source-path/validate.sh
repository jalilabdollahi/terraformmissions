#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'module[[:space:]]+"grading"' "the module call must keep the name \"grading\""
grep -q 'local_file' main.tf 2>/dev/null && tm_fail "main.tf must not create the label itself — the module does that"

tm_init "terraform init could not install the module — check what the init output says about the source"
tm_apply
tm_assert_in_state module.grading.local_file.label "the label is not managed inside module.grading"

tm_assert_output label_file "./labels/glenburn-second.txt"
tm_assert_file_equals labels/glenburn-second.txt $'ESTATE GLENBURN\nFLUSH second\nGRADE SFTGFOP\n'

# Different inputs must flow through the module too
tm_apply -var flush=autumn -var estate=Makaibari
tm_assert_file_equals labels/makaibari-autumn.txt $'ESTATE MAKAIBARI\nFLUSH autumn\nGRADE TGFOP\n'

tm_apply
tm_assert_no_changes
tm_pass "module.grading resolves to modules/grader and labels the harvest"
