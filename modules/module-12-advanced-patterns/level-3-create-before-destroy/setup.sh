#!/usr/bin/env bash
source "$TM_LIB"
# Last week's advert is already on the billboard: apply the previous version of main.tf.
cp main.tf "$TM_TMP/main.tf.this-week"
cp "$LEVEL_PATH/legacy/main.tf" main.tf
tm_apply
tm_record old_id "$(tm_state_attr local_file.billboard id)"
cp "$TM_TMP/main.tf.this-week" main.tf
