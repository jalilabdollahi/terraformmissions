#!/usr/bin/env bash
source "$TM_LIB"
# Hand edit, done carefully: back up, restore keys from out/inspection-log.txt, reset schema versions, bump serial.
cp terraform.tfstate terraform.tfstate.pre-edit
python3 - <<'PY'
import json
log = [l.split() for l in open("out/inspection-log.txt") if l.strip()]
tags = {hexv: name for kind, name, hexv in log if kind == "cabin"}
limits = {val: name for kind, name, val in log if kind == "limit"}
p = "terraform.tfstate"
s = json.load(open(p))
for r in s["resources"]:
    if r["type"] == "random_id":
        for inst in r["instances"]:
            inst["index_key"] = tags[inst["attributes"]["hex"]]
            inst["schema_version"] = 0
    elif r["type"] == "random_integer":
        for inst in r["instances"]:
            inst["index_key"] = limits[str(inst["attributes"]["result"])]
            inst["schema_version"] = 0
s["serial"] += 1
json.dump(s, open(p, "w"), indent=2)
PY
terraform plan
