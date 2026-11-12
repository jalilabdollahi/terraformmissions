#!/usr/bin/env bash
source "$TM_LIB"
# Apply the configuration as it looked BEFORE the refactor (resources in the root module),
# then put the refactored code back.
cp main.tf "$TM_TMP/main.tf.refactored"
cp "$LEVEL_PATH/legacy/main.tf" main.tf
tm_apply
tm_record ticket "$(tm_state_attr random_id.ticket hex)"
tm_record manifest_id "$(tm_state_attr local_file.manifest id)"
cp "$TM_TMP/main.tf.refactored" main.tf
