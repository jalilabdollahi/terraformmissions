#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'module[[:space:]]+"grading"' "the module call must keep the name \"grading\""
grep -q 'local_file' main.tf 2>/dev/null && tm_fail "main.tf must not create the label itself — the module does that"

tm_init "terraform init could not install the module — check what the init output says about the source"
tm_apply
tm_assert_in_state module.grading.local_file.label "the label is not managed inside module.grading"

tm_assert_output label_file "./labels/tarndale-summer.txt"
tm_assert_file_equals labels/tarndale-summer.txt $'FARM TARNDALE\nCLIP summer\nGRADE FINE64\n'

# Different inputs must flow through the module too
tm_apply -var clip=autumn -var farm=Ridgemont
tm_assert_file_equals labels/ridgemont-autumn.txt $'FARM RIDGEMONT\nCLIP autumn\nGRADE MEDIUM58\n'

tm_apply
tm_assert_no_changes
tm_pass "module.grading resolves to modules/grader and labels the clip"
