#!/usr/bin/env bash
source "$TM_LIB"
# 1. The real, complete state (what the last good run produced).
TM_MSG="initial apply failed" tm_apply
for k in asha bram cleo; do tm_record "badge_$k" "$(tm_state_attr "random_id.keeper_badge[\"$k\"]" hex)"; done
for a in otters owls; do tm_record "slot_$a" "$(tm_state_attr "random_integer.enclosure_slot[\"$a\"]" result)"; done
tm_record epoch "$(tm_state_attr random_uuid.rota_epoch result)"
tm_record rota "$(tm_state_attr local_file.feeding_rota id)"
BAY=$(tm_state_attr random_integer.quarantine_bay result)
tm_record bay "$BAY"
tm_record lineage "$(terraform state pull | jq -r .lineage)"

# 2. Forge the history: stale copies, a corrupt artifact, and another project's state.
mkdir -p recovery
python3 - "$BAY" <<'PY'
import copy, json, sys
bay = sys.argv[1]
full = json.load(open("terraform.tfstate"))
lineage = full["lineage"]

def variant(serial, drop):
    s = copy.deepcopy(full)
    s["serial"] = serial
    s["outputs"] = {}
    keep = []
    for r in s["resources"]:
        key = (r["type"], r["name"])
        insts = []
        for i in r["instances"]:
            if (key, i.get("index_key")) in drop or (key, None) in drop and "index_key" not in i:
                continue
            insts.append(i)
        if insts:
            r["instances"] = insts
            keep.append(r)
    s["resources"] = keep
    return s

bay_key = (("random_integer", "quarantine_bay"), None)
cleo = (("random_id", "keeper_badge"), "cleo")
owls = (("random_integer", "enclosure_slot"), "owls")

stale_live = variant(9, [bay_key, cleo, owls])
backup = variant(8, [bay_key, cleo, owls])
mon = variant(11, [bay_key, cleo, owls])
tue = variant(15, [bay_key])
ci = variant(16, [])
with open("terraform.tfstate", "w") as f: json.dump(stale_live, f, indent=2)
with open("terraform.tfstate.backup", "w") as f: json.dump(backup, f, indent=2)
with open("recovery/fenwick-state-mon-0400.json", "w") as f: json.dump(mon, f, indent=2)
with open("recovery/fenwick-state-tue-1200.json", "w") as f: json.dump(tue, f, indent=2)
txt = json.dumps(ci, indent=2)
with open("recovery/ci-artifact-run-217.json", "w") as f: f.write(txt[: int(len(txt) * 0.62)])
other = {
    "version": 4, "terraform_version": "1.17.2", "serial": 40,
    "lineage": "5d0c7a2e-9b61-4c1f-8f3a-2f6e0a7c1b44", "outputs": {},
    "resources": [{
        "mode": "managed", "type": "random_id", "name": "hotline_key",
        "provider": 'provider["registry.terraform.io/hashicorp/random"]',
        "instances": [{"schema_version": 0, "attributes": {
            "b64_std": "qrvM3Q==", "b64_url": "qrvM3Q", "byte_length": 4, "dec": "2864434397",
            "hex": "aabbccdd", "id": "qrvM3Q", "keepers": None, "prefix": None}, "sensitive_attributes": []}],
    }],
    "check_results": None,
}
with open("recovery/rescue-hotline-service.json", "w") as f: json.dump(other, f, indent=2)
PY
cat >recovery/ci-run-217-apply.log <<LOG
Run #217 (Wed 14:02) - terraform apply -auto-approve
random_integer.quarantine_bay: Creating...
random_integer.quarantine_bay: Creation complete after 0s [id=$BAY]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
Uploading terraform.tfstate to artifact store ... FAILED (timeout after 30s)
Artifact recovery/ci-artifact-run-217.json is partial.
LOG
# The VM's live state is now the stale copy the other team pushed over it.
