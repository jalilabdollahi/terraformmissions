#!/usr/bin/env bash
source "$TM_LIB"
# Build the state at the OLD location, then switch the code to the NEW path without re-initialising.
cp terraform.tf "$TM_TMP/new-terraform.tf"
python3 - <<'PY'
import pathlib
p = pathlib.Path("terraform.tf")
p.write_text(p.read_text().replace("vault/kiosks-prod.tfstate", "state/kiosks.tfstate"))
PY
terraform init -reconfigure -input=false -no-color >"$TM_LAST_OUT" 2>&1 || { tm_show_last; exit 1; }
tm_apply
tm_record serial "$(tm_state_attr random_id.kiosk_serial hex)"
tm_record interval "$(tm_state_attr random_integer.refresh_interval result)"
cp "$TM_TMP/new-terraform.tf" terraform.tf
