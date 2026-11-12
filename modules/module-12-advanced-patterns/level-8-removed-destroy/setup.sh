#!/usr/bin/env bash
source "$TM_LIB"
# All three targets exist; target 7's resource block was then deleted from the code.
cp main.tf "$TM_TMP/main.tf.closing"
cp "$LEVEL_PATH/legacy/main.tf" main.tf
tm_apply
tm_record target5 "$(tm_state_attr local_file.target_5 id)"
tm_record target6 "$(tm_state_attr local_file.target_6 id)"
cp "$TM_TMP/main.tf.closing" main.tf
