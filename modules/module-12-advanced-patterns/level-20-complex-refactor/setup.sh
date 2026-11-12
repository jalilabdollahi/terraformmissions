#!/usr/bin/env bash
source "$TM_LIB"
# Apply the pre-refactor configuration (count-indexed, with the mascot), remember the identities.
cp main.tf "$TM_TMP/main.tf.refactored"
cp "$LEVEL_PATH/legacy/main.tf" main.tf
tm_apply
i=0
for name in freestyle dodgeball ninja; do
  tm_record "band_$name" "$(tm_state_attr "random_id.band[$i]" hex)"
  tm_record "card_$name" "$(tm_state_attr "local_file.court_card[$i]" id)"
  i=$((i+1))
done
tm_record mascot "$(tm_state_attr random_pet.mascot id)"
cp "$TM_TMP/main.tf.refactored" main.tf
