#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
HEX=$(tm_state_attr random_id.freezer_tag hex)
URL=$(tm_state_attr random_id.freezer_tag b64_url)
tm_record tag_id "$URL"
tm_record label_id "$(tm_state_attr local_file.door_label id)"
mkdir -p inventory
cat > inventory/asset-sticker.txt <<NOTE
Sticker photographed on the freezer door (Coldharbor Clinic, room B2)

  Printed hex form ........ ${HEX}
  Barcode (URL-safe b64) .. ${URL}

The old state file was lost in the laptop swap.
NOTE
# The lost state: the tag is forgotten, the door label stays tracked.
terraform state rm random_id.freezer_tag >/dev/null
