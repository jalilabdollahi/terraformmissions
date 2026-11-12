#!/usr/bin/env bash
source "$TM_LIB"
# 1. The last healthy night: apply the correct code (solution overlay), record the truth.
cp -R "$LEVEL_PATH/solution/." .
TM_MSG="healthy apply failed" tm_apply
tm_record generator "$(tm_state_attr module.power.random_id.generator_serial hex)"
tm_record fuel "$(tm_state_attr module.power.random_integer.fuel_litres result)"
tm_record radio "$(tm_state_attr module.comms.random_id.radio_key hex)"
tm_record channel "$(tm_state_attr module.comms.random_integer.channel result)"
tm_record dailies_id "$(tm_state_attr terraform_data.dailies id)"
tm_record sheet_id "$(tm_state_attr module.comms.local_file.comms_sheet id)"
tm_record manifest_id "$(tm_state_attr local_file.base_manifest id)"
tm_record lineage "$(jq -r .lineage terraform.tfstate)"
tm_record sheet "$(cat out/comms-sheet.txt)"

# 2. A panicking colleague taints two objects "to be safe"; the dailies run really did fail.
terraform taint terraform_data.dailies >"$TM_LAST_OUT" 2>&1 || { tm_show_last; tm_fail "taint failed"; }
terraform taint module.comms.random_id.radio_key >"$TM_LAST_OUT" 2>&1 || { tm_show_last; tm_fail "taint failed"; }
printf 'dailies FAILED - upload timeout\n' >out/dailies.txt

# 3. Corrupt state, and a backup that predates the fuel tank.
python3 - <<'PY'
import json
s = json.load(open("terraform.tfstate"))
raw = open("terraform.tfstate").read()
b = json.loads(raw)
b["serial"] -= 1
for r in b["resources"]:
    if r["type"] == "random_integer" and r["name"] == "fuel_litres":
        b["resources"].remove(r)
        break
json.dump(b, open("terraform.tfstate.backup", "w"), indent=2)
open("terraform.tfstate", "w").write(raw[: int(len(raw) * 0.55)])
PY
# 4. Drift: someone edited the radio sheet on the base laptop.
printf 'radio 000000 channel 99 powered-by EDITED-BY-OPS\n' >out/comms-sheet.txt
# 5. The shipped (broken) code goes back in, including the module renames and type mistake.
cp -R "$LEVEL_PATH/broken/." .
