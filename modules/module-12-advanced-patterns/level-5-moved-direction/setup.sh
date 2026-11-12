#!/usr/bin/env bash
source "$TM_LIB"
# The abbot's seal key was created under its old name, "seal".
cp main.tf "$TM_TMP/main.tf.renamed"
cp "$LEVEL_PATH/legacy/main.tf" main.tf
tm_apply
tm_record fingerprint "$(tm_state_attr tls_private_key.seal public_key_fingerprint_sha256)"
tm_record register_id "$(tm_state_attr local_file.seal_register id)"
cp "$TM_TMP/main.tf.renamed" main.tf
