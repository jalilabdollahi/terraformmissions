#!/usr/bin/env bash
source "$TM_LIB"
terraform state pull > "$TM_TMP/before.tfstate"
PINE_TAG=$(sed -n 's/.*lot=pine .*tag=\([0-9]*\).*/\1/p' ledger/handshakes.log)
sed -i.bak "s/PINE_TAG/$PINE_TAG/" import.tf && rm -f import.tf.bak
terraform untaint 'terraform_data.kiln_run["pine"]'
terraform apply -auto-approve
