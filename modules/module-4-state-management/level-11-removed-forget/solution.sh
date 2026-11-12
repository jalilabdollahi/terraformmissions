#!/usr/bin/env bash
source "$TM_LIB"
python3 - <<'PY'
import pathlib
p = pathlib.Path("main.tf")
t = p.read_text()
i = t.index('resource "local_file" "permit_book"')
t = t[:i] + '''removed {
  from = local_file.permit_book

  lifecycle {
    destroy = false
  }
}
'''
p.write_text(t)
PY
terraform plan
terraform apply -auto-approve
