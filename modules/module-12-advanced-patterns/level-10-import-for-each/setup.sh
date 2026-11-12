#!/usr/bin/env bash
source "$TM_LIB"
# The workshop's shaper codename already exists in state; the job tickets do not.
cp main.tf "$TM_TMP/main.tf.import"
cp "$LEVEL_PATH/legacy/main.tf" main.tf
tm_apply
tm_record shaper "$(tm_state_attr random_pet.shaper id)"
cp "$TM_TMP/main.tf.import" main.tf
