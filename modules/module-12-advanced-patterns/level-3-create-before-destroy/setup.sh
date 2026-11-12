#!/usr/bin/env bash
source "$TM_LIB"
# Last week's feature is already on the sign: apply the previous version of main.tf.
cp main.tf "$TM_TMP/main.tf.tonight"
cp "$LEVEL_PATH/legacy/main.tf" main.tf
tm_apply
tm_record old_id "$(tm_state_attr local_file.marquee id)"
cp "$TM_TMP/main.tf.tonight" main.tf
