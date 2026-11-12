#!/usr/bin/env bash
source "$TM_LIB"
# The healthy line first.
TM_MSG="initial apply failed" tm_apply
for k in alpine birch cedar dale; do
  tm_record "tag_$k" "$(tm_state_attr "random_id.cabin_tag[\"$k\"]" hex)"
done
for k in base top; do
  tm_record "limit_$k" "$(tm_state_attr "module.station.random_integer.load_limit[\"$k\"]" result)"
done
tm_record log_id "$(tm_state_attr local_file.inspection_log id)"
tm_record lineage "$(jq -r .lineage terraform.tfstate)"

# Then the accident: a teammate's migration script, run with a pre-release provider build,
# rewrote the instance keys as positions and stamped a newer schema version on every instance.
python3 - <<'PY'
import json
p = "terraform.tfstate"
s = json.load(open(p))
for r in s["resources"]:
    if r["type"] not in ("random_id", "random_integer"):
        continue
    for pos, inst in enumerate(sorted(r["instances"], key=lambda i: str(i["index_key"]))):
        inst["index_key"] = pos
        inst["schema_version"] = 7
s["serial"] += 2
json.dump(s, open(p, "w"), indent=2)
print(s["serial"])
PY
tm_record broken_serial "$(jq -r .serial terraform.tfstate)"
