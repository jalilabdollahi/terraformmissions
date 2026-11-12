#!/usr/bin/env bash
source "$TM_LIB"
terraform untaint tls_private_key.firmware_signer
terraform plan
