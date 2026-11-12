#!/usr/bin/env bash
source "$TM_LIB"
# Build the production state at its real location first.
cp terraform.tf "$TM_TMP/terraform.tf"
cp "$TM_TMP/terraform.tf" "$TM_TMP/wrong.tf"
python3 - <<'PY'
import pathlib
p = pathlib.Path("terraform.tf")
p.write_text(p.read_text().replace("state/tuktuk.tfstate", "states/tuktuk-prod.tfstate"))
PY
terraform init -reconfigure -input=false -no-color >"$TM_LAST_OUT" 2>&1 || { tm_show_last; exit 1; }
tm_apply
tm_record tuktuk "$(tm_state_attr random_pet.tuktuk_name id)"
tm_record minute "$(tm_state_attr random_integer.departure_minute result)"
# The reshuffle: config now points at an empty location.
cp "$TM_TMP/terraform.tf" terraform.tf
terraform init -reconfigure -input=false -no-color >"$TM_LAST_OUT" 2>&1 || { tm_show_last; exit 1; }
