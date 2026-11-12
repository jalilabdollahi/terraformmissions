#!/usr/bin/env bash
source "$TM_LIB"
# Apply the configuration as it was BEFORE the rename, then restore the renamed code.
cp main.tf "$TM_TMP/main.tf"
python3 - <<'PY'
import pathlib
p = pathlib.Path("main.tf")
p.write_text(p.read_text().replace("night_keeper", "keeper"))
PY
tm_apply
tm_record codename "$(tm_output_raw keeper_codename)"
cp "$TM_TMP/main.tf" main.tf
