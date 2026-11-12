#!/usr/bin/env bash
source "$TM_LIB"
python3 - <<'PY'
import pathlib, re
p = pathlib.Path("modules/annex/main.tf")
t = re.sub(r"\n  # Added.*?\n  \}\n", "", p.read_text(), flags=re.S)
p.write_text(t)
m = pathlib.Path("main.tf")
t = m.read_text()
t = t.replace('annex = tostring(var.annex_enabled)\n  }', 'annex = "true"\n  }\n\n  lifecycle {\n    prevent_destroy = true\n  }')
t = t.replace("    annex    berth ${module.annex[0].berth_tag}, crane slot ${module.annex[0].crane_slot}\n", "")
m.write_text(t)
PY
terraform apply -auto-approve
