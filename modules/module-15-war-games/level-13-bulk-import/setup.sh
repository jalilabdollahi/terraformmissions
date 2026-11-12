#!/usr/bin/env bash
source "$TM_LIB"
# Only the network key is under Terraform so far; the gauges are real but unmanaged.
TM_MSG="initial network key apply failed" tm_apply -target=random_id.network_key
tm_record network_key "$(tm_state_attr random_id.network_key hex)"
