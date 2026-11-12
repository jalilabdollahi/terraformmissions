#!/usr/bin/env bash
source "$TM_LIB"

# Apply the original config (shifts of 24h), then restore the new code (12h).
cp main.tf "$TM_TMP/main.tf"
python3 - <<'PY'
import pathlib
p = pathlib.Path("main.tf")
t = p.read_text().replace("shift_length_hours = 12", "shift_length_hours = 24")
t = t.replace("ignore_changes = [contents, body]", "ignore_changes = []")
p.write_text(t)
PY
tm_apply
tm_record notes "$(cat journal/build-notes.txt)"
cp "$TM_TMP/main.tf" main.tf
