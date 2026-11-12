#!/usr/bin/env bash
source "$TM_LIB"
cp main.tf "$TM_TMP/main.tf"
# The code as it was before the refactor, including the (since removed) gauge log.
python3 - <<'PY'
import pathlib
p = pathlib.Path("main.tf")
t = p.read_text().replace("combine_operator", "harvester")
t += '''
resource "local_file" "retired_gauge_log" {
  filename = "${path.module}/gauges/retired-gauge-log.txt"
  content  = "Gauge G-7 retired after the 2019 flood. Readings archived.\\n"
}
'''
p.write_text(t)
PY
tm_apply
tm_record operator "$(tm_state_attr random_pet.harvester id)"
tm_record silo "$(tm_state_attr random_integer.silo_number result)"
tm_record gauge_sha "$(tm_state_attr local_file.retired_gauge_log content_sha1)"
tm_record sheet_id "$(tm_state_attr local_file.dispatch_sheet id)"
mkdir -p plates
cat > plates/silo-plate.txt <<NOTE
Photo of the silo nameplate (Three Rivers Co-op, east yard)
  Silo number .......... $(tm_recall silo)
  Allocation range ..... 100 to 999
NOTE
# Accident: the silo number was dropped from state.
terraform state rm random_integer.silo_number >/dev/null
cp "$TM_TMP/main.tf" main.tf
