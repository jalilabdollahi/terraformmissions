#!/usr/bin/env bash
source "$TM_LIB"

# Apply the config as it was before the prefix rename, then restore the new code.
cp main.tf "$TM_TMP/main.tf"
python3 - <<'PY'
import pathlib
p = pathlib.Path("main.tf")
p.write_text(p.read_text().replace('prefix = "depot"', 'prefix = "yard"'))
PY
tm_apply
tm_record ledger "$(tm_state_attr random_uuid.ledger id)"
tm_record shelf "$(tm_state_attr random_pet.shelf_label id)"
cp "$TM_TMP/main.tf" main.tf
