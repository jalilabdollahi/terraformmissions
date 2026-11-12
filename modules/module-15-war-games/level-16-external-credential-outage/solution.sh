#!/usr/bin/env bash
source "$TM_LIB"
# variables fix (region "north-sea") comes with the solution overlay.
jq -r '.services["quota-registry"].token' handoff/vault-export.json >.credentials/quota-token
chmod 600 .credentials/quota-token
terraform apply -auto-approve
