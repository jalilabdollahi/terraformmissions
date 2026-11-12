#!/usr/bin/env bash
source "$TM_LIB"
mkdir -p recovery
# 1. Early life: the archive index still existed.
cat > archive.tf <<'TF'
resource "local_file" "archive_index" {
  filename = "${path.module}/docket/archive-index.txt"
  content  = "archive for seal ${random_id.docket_seal.hex}\n"
}
TF
tm_apply
cp terraform.tfstate "$TM_TMP/snapshot.json"
# 2. Later: the archive index was decommissioned and courtroom c3 was re-rolled on purpose
#    (CHG-0710: call-sign clash with the county court).
rm -f archive.tf
terraform apply -auto-approve -input=false -no-color -replace='random_pet.courtroom["c3"]' >"$TM_LAST_OUT" 2>&1 || exit 1
tm_record seal "$(tm_state_attr random_id.docket_seal id)"
for c in c1 c2 c3; do tm_record "pet_$c" "$(tm_state_attr "random_pet.courtroom[\"$c\"]" id)"; done
python3 - <<'PY'
import json, uuid, pathlib
# 3. A botched `state rm` session wipes the seal and c2's call-sign from the LIVE state.
live = json.loads(pathlib.Path("terraform.tfstate").read_text())
new = []
for r in live["resources"]:
    if r["type"] == "random_id" and r["name"] == "docket_seal":
        continue
    if r["type"] == "random_pet" and r["name"] == "courtroom":
        r["instances"] = [i for i in r["instances"] if i["index_key"] != "c2"]
    new.append(r)
live["resources"] = new
live["serial"] += 1
pathlib.Path("terraform.tfstate").write_text(json.dumps(live, indent=2))
pathlib.Path(".tm").mkdir(exist_ok=True)
pathlib.Path(".tm/lineage").write_text(live["lineage"])
pathlib.Path(".tm/serial").write_text(str(live["serial"]))
# 4. The clerk's laptop copy, taken before all that: it was re-initialised, so it has its own lineage.
snap = json.loads(pathlib.Path(__import__("os").environ["TM_TMP"], "snapshot.json").read_text())
snap["lineage"] = str(uuid.uuid4())
snap["serial"] = 3
pathlib.Path("recovery/docket-snapshot.tfstate").write_text(json.dumps(snap, indent=2))
PY
exit 0
