#!/usr/bin/env bash
source "$TM_LIB"
# 1. The court already runs two hearings.
cp main.tf "$TM_TMP/main.tf"
python3 - <<'PY'
import pathlib, re
p = pathlib.Path("main.tf")
t = p.read_text()
t = re.sub(r'    "c-3013".*\n    "c-3014".*\n    "c-3015".*\n', '', t)
p.write_text(t)
PY
tm_apply
cp "$TM_TMP/main.tf" main.tf
# 2. The registrar signs off on a plan adding the other three.
terraform plan -input=false -no-color -out=plan.tfplan >"$TM_LAST_OUT" 2>&1 || { tm_show_last; exit 1; }
tm_record stale_plan "$(shasum plan.tfplan | cut -d' ' -f1)"
# 3. Another clerk applies one of the three by hand, making the saved plan stale.
terraform apply -auto-approve -input=false -no-color -target='local_file.docket["c-3013"]' >"$TM_LAST_OUT" 2>&1 \
  || { tm_show_last; exit 1; }
