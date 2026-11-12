#!/usr/bin/env bash
source "$TM_LIB"
cp terraform.tfstate "$TM_TMP/state.backup"
terraform untaint random_id.heat_lot
python3 - <<'PY'
import pathlib, re
p = pathlib.Path("main.tf")
t = p.read_text()
t = t.replace("pour_temp_c    = 1380", "pour_temp_c    = 1450")
t = re.sub(r'resource "local_file" "mold_c" \{.*?\n\}\n\n', "", t, flags=re.S)
p.write_text(t)
PY
terraform apply -auto-approve
