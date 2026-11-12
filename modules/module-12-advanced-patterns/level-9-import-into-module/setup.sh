#!/usr/bin/env bash
source "$TM_LIB"
# The hut module already exists in state, but only its mascot: the key was never imported.
cp main.tf "$TM_TMP/main.tf.import"
cp "$LEVEL_PATH/legacy/main.tf" main.tf
tm_apply -target=module.hut.random_pet.mascot
tm_record mascot "$(tm_state_attr module.hut.random_pet.mascot id)"
cp "$TM_TMP/main.tf.import" main.tf
