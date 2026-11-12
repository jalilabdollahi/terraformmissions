#!/usr/bin/env bash
source "$TM_LIB"
# Reproduce the history: everything was applied years ago with tls 3.4.0 / local 2.4.0.
cp main.tf "$TM_TMP/main.tf.new"
cp terraform.tf "$TM_TMP/terraform.tf.new"
cp "$LEVEL_PATH/legacy/main.tf" main.tf
cp "$LEVEL_PATH/legacy/terraform.tf" terraform.tf
rm -f .terraform.lock.hcl
terraform init -input=false -no-color >/dev/null 2>&1 || exit 1
tm_apply
tm_record ca_key_id "$(tm_state_attr tls_private_key.ca id)"
tm_record sorter_key_id "$(tm_state_attr tls_private_key.sorter id)"
tm_record ca_pub "$(tm_state_attr tls_private_key.ca public_key_fingerprint_sha256)"
# ...then the constraint bump and a refactor landed on main: the lock file is the old one.
cp "$TM_TMP/main.tf.new" main.tf
cp "$TM_TMP/terraform.tf.new" terraform.tf
exit 0
