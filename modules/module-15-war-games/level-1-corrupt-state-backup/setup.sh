#!/usr/bin/env bash
source "$TM_LIB"
# Build the history: the state on disk is one apply behind the code.
cp main.tf "$TM_TMP/main.tf.final"
python3 - <<'PY'
import pathlib, re
p = pathlib.Path("main.tf")
t = p.read_text()
t = re.sub(r"\n    west .*", "", t)          # the west dish did not exist yet
t = t.replace("north = { band_mhz = 1420.4", "north = { band_mhz = 1420.0")
p.write_text(t)
PY
tm_apply
for d in north south east; do
  tm_record "id_$d" "$(tm_state_attr "random_id.receiver[\"$d\"]" id)"
done
cp "$TM_TMP/main.tf.final" main.tf
# Second apply: adds the west dish and retunes north. Terraform copies the
# previous state to terraform.tfstate.backup first.
tm_apply
tm_record id_west "$(tm_state_attr 'random_id.receiver["west"]' id)"
# The disk filled up in the middle of a state write: the file is cut off.
python3 - <<'PY'
import pathlib
p = pathlib.Path("terraform.tfstate")
b = p.read_bytes()
p.write_bytes(b[: int(len(b) * 0.55)])
PY
exit 0
