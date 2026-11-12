#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_record fingerprint "$(tm_state_attr tls_private_key.firmware_signer public_key_fingerprint_sha256)"
tm_record pub_id "$(tm_state_attr local_file.bootloader_pubkey id)"
# The false alarm: someone marked the key as tainted.
terraform taint tls_private_key.firmware_signer >/dev/null
