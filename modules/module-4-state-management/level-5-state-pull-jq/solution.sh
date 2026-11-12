#!/usr/bin/env bash
source "$TM_LIB"
mkdir -p answers
terraform state pull | jq -r '.serial'  > answers/serial.txt
terraform state pull | jq -r '.lineage' > answers/lineage.txt
terraform state pull | jq -r '.resources[] | select(.type == "random_id" and .name == "lot_seal") | .instances[0].attributes.hex' > answers/seal-hex.txt
