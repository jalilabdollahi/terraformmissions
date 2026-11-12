#!/usr/bin/env bash
source "$TM_LIB"
# The north shaft was inspected when its module call was still named shaft_a.
cp main.tf "$TM_TMP/main.tf.renamed"
cp "$LEVEL_PATH/legacy/main.tf" main.tf
tm_init
tm_apply
tm_record north_tag "$(tm_state_attr module.shaft_a.random_id.tag hex)"
tm_record north_file "$(tm_state_attr module.shaft_a.local_file.placard id)"
tm_record south_tag "$(tm_state_attr module.south_shaft.random_id.tag hex)"
cp "$TM_TMP/main.tf.renamed" main.tf
tm_init
