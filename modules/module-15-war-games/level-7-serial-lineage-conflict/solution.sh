#!/usr/bin/env bash
source "$TM_LIB"
cp terraform.tfstate "$TM_TMP/live-before.tfstate"
python3 - <<'PY'
import json, pathlib
live = json.loads(pathlib.Path("terraform.tfstate").read_text())
snap = json.loads(pathlib.Path("recovery/docket-snapshot.tfstate").read_text())
for r in snap["resources"]:
    if r["type"] == "random_id" and r["name"] == "docket_seal":
        live["resources"].append(r)
    if r["type"] == "random_pet" and r["name"] == "courtroom":
        mine = [x for x in live["resources"] if x["type"] == "random_pet"][0]
        mine["instances"] += [i for i in r["instances"] if i["index_key"] == "c2"]
live["serial"] += 1
pathlib.Path("merged.tfstate").write_text(json.dumps(live, indent=2))
PY
terraform state push merged.tfstate
terraform apply -auto-approve
