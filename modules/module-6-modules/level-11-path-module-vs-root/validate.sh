#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'path\.module' "the template belongs to the module, so it should be found relative to the module"
tm_assert_config_has 'path\.root' "the finished script is a workspace artefact, so it should be placed relative to the root"
tm_assert_file modules/guide/templates/narration.tpl "the template must stay inside the module"

tm_init
TM_MSG="terraform apply failed — which of the two paths points to the wrong directory?" tm_apply

tm_assert_in_state module.guide.local_file.script
tm_assert_output audio_file "./audio/haunted-cellar.txt"
tm_assert_no_file modules/guide/audio/haunted-cellar.txt "the script was written inside modules/guide instead of the workspace audio/ folder"
tm_assert_file_contains audio/haunted-cellar.txt "to the haunted cellar stop" "the script does not greet the stop"
tm_assert_file_contains audio/haunted-cellar.txt "This is Edith speaking" "the narrator is missing from the script"

tm_apply -var stop=plague-pit -var narrator=Rosalind
tm_assert_output audio_file "./audio/plague-pit.txt"
tm_assert_file_contains audio/plague-pit.txt "to the plague pit stop"
tm_assert_file_contains audio/plague-pit.txt "This is Rosalind speaking"
tm_assert_no_file modules/guide/audio/plague-pit.txt "the script was written inside modules/guide"

tm_apply
tm_assert_no_changes
tm_pass "templates are read from the module, scripts are written to the root"
