#!/usr/bin/env bash
source "$TM_LIB"
TAG=$(awk '/Barcode/ { print $NF }' inventory/asset-sticker.txt)
terraform import random_id.freezer_tag "$TAG"
terraform plan
