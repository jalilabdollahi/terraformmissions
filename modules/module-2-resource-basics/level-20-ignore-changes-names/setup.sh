#!/usr/bin/env bash
source "$TM_LIB"

# Apply the original config (feeding every 24h), then restore the new code (12h).
cp main.tf "$TM_TMP/main.tf"
python3 - <<'PY'
import pathlib
p = pathlib.Path("main.tf")
t = p.read_text().replace("feeding_every_hours = 12", "feeding_every_hours = 24")
t = t.replace("ignore_changes = [contents, body]", "ignore_changes = []")
p.write_text(t)
PY
tm_apply
tm_record notes "$(cat journal/starter-notes.txt)"
cp "$TM_TMP/main.tf" main.tf
