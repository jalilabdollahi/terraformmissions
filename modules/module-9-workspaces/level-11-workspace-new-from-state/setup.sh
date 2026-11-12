#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_record blend "$(tm_output_raw blend_name)"
mkdir -p snapshots
cp terraform.tfstate snapshots/tea-ledger.tfstate
# The default workspace's own state is gone; only the snapshot remains.
rm -f terraform.tfstate terraform.tfstate.backup
