#!/usr/bin/env bash
source "$TM_LIB"
terraform workspace new -state=snapshots/tea-ledger.tfstate rehearsal
terraform plan
