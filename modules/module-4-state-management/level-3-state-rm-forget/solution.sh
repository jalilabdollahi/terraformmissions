#!/usr/bin/env bash
source "$TM_LIB"
terraform state rm local_file.stud_book
python3 - <<'PY'
import pathlib
p = pathlib.Path("main.tf")
t = p.read_text()
t = t[: t.index('resource "local_file" "stud_book"')].rstrip() + "\n"
p.write_text(t)
PY
terraform plan
