#!/usr/bin/env bash
source "$TM_LIB"
# Apply the approved banner and the 06:00 feed, then let the logger move on and restore
# the colleague's unreviewed edit.
cp variables.tf "$TM_TMP/variables.tf"
python3 - <<'PY'
import pathlib
p = pathlib.Path("variables.tf")
t = p.read_text().replace("Gauge 07 - recalibrated with the umbrella sensor, readings x1.04", "Gauge 07 - Pellam Moor north slope")
p.write_text(t)
PY
tm_apply
tm_record banner "$(cat banner.txt)"
cp "$TM_TMP/variables.tf" variables.tf
printf '%s\n' '{"station": "gauge-07", "rainfall_mm": 11.8, "updated": "09:30"}' > feeds/gauge-07.json
