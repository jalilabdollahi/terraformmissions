#!/usr/bin/env bash
source "$TM_LIB"
# The master key was created under its old name, "master".
cp main.tf "$TM_TMP/main.tf.renamed"
cp "$LEVEL_PATH/legacy/main.tf" main.tf
tm_apply
tm_record fingerprint "$(tm_state_attr tls_private_key.master public_key_fingerprint_sha256)"
tm_record register_id "$(tm_state_attr local_file.key_register id)"
cp "$TM_TMP/main.tf.renamed" main.tf
