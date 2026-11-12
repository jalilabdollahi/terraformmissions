#!/usr/bin/env bash
source "$TM_LIB"
# Apply the code as it was BEFORE the refactor, then restore the renamed code.
cp main.tf "$TM_TMP/main.tf"
python3 - <<'PY'
import pathlib
p = pathlib.Path("main.tf")
t = p.read_text().replace("climb_pass", "zip_pass").replace("harness_sign", "gate_sign")
p.write_text(t)
PY
tm_apply
tm_record pass_id "$(tm_state_attr random_id.zip_pass id)"
tm_record sign_id "$(tm_state_attr local_file.gate_sign id)"
cp "$TM_TMP/main.tf" main.tf
