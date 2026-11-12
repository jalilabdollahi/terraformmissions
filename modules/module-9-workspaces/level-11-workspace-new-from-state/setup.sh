#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_record batch "$(tm_output_raw batch_name)"
mkdir -p snapshots
cp terraform.tfstate snapshots/jam-ledger.tfstate
# The default workspace's own state is gone; only the snapshot remains.
rm -f terraform.tfstate terraform.tfstate.backup
