#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'path\.module' "the template belongs to the module, so it should be found relative to the module"
tm_assert_config_has 'path\.root' "the finished script is a workspace artefact, so it should be placed relative to the root"
tm_assert_file modules/guide/templates/narration.tpl "the template must stay inside the module"

tm_init
TM_MSG="terraform apply failed — which of the two paths points to the wrong directory?" tm_apply

tm_assert_in_state module.guide.local_file.script
tm_assert_output audio_file "./audio/steam-loco.txt"
tm_assert_no_file modules/guide/audio/steam-loco.txt "the script was written inside modules/guide instead of the workspace audio/ folder"
tm_assert_file_contains audio/steam-loco.txt "to the steam loco gallery" "the script does not greet the exhibit"
tm_assert_file_contains audio/steam-loco.txt "This is Edith speaking" "the narrator is missing from the script"

tm_apply -var exhibit=dining-car -var narrator=Rosalind
tm_assert_output audio_file "./audio/dining-car.txt"
tm_assert_file_contains audio/dining-car.txt "to the dining car gallery"
tm_assert_file_contains audio/dining-car.txt "This is Rosalind speaking"
tm_assert_no_file modules/guide/audio/dining-car.txt "the script was written inside modules/guide"

tm_apply
tm_assert_no_changes
tm_pass "templates are read from the module, scripts are written to the root"
