#!/usr/bin/env bash
source "$TM_LIB"
# The ledger exists as a null_resource and its ID is already printed on shot cards.
cp main.tf "$TM_TMP/main.tf.new"
cp "$LEVEL_PATH/legacy/main.tf" main.tf
tm_apply
tm_record ledger_id "$(tm_state_attr null_resource.launch_ledger id)"
tm_record card_id "$(tm_state_attr local_file.shot_card id)"
cp "$TM_TMP/main.tf.new" main.tf
