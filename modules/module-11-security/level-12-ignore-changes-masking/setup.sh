#!/usr/bin/env bash
source "$TM_LIB"
# production today: the old, wide-open rules, applied before anybody added ignore_changes
cp main.tf "$TM_TMP/main.tf.keep"
python3 - <<'PY'
import pathlib, re
p = pathlib.Path("main.tf")
t = p.read_text()
t = t.replace("10.20.0.0/16", "0.0.0.0/0").replace('"0640"', '"0666"')
t = re.sub(r"(?s)\n  # \"the plan keeps.*?\n  \}\n", "\n", t)
p.write_text(t)
PY
tm_apply
cp "$TM_TMP/main.tf.keep" main.tf
