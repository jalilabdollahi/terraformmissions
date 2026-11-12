#!/usr/bin/env bash
source "$TM_LIB"
terraform workspace new -state=snapshots/jam-ledger.tfstate rehearsal
terraform plan
