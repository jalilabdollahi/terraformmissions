#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
# The night technician edits the live file: hotter and longer.
python3 - <<'PY'
import pathlib
p = pathlib.Path("kiln/firing-schedule.txt")
t = p.read_text().replace("1260", "1320").replace("hold_minutes: 25", "hold_minutes: 40")
p.write_text(t)
PY
tm_record glaze_id "$(tm_state_attr local_file.glaze_notes id)"
