#!/usr/bin/env bash
source "$TM_LIB"
terraform state pull > "$TM_TMP/before.tfstate"
python3 - <<'PY'
import pathlib
p = pathlib.Path("main.tf")
p.write_text(p.read_text().replace("values(module.hall_b[0].stand_names))}", "try(values(module.hall_b[0].stand_names), []))}"))
PY
kill -0 4242 2>/dev/null && { echo "pid 4242 alive"; exit 1; }
rm -f crates/manifest.lock
terraform apply -auto-approve
rm -f signage/s3.txt
