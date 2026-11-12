#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"local_file"' "the register must still be read through a local_file data source"
if grep -qE 'K-0[0-9]' main.tf; then tm_fail "boat ids must come from the register, not from the config"; fi

tm_apply
tm_assert_output_jq ready_by_class '. == {"river":["K-01","K-04"],"sea":["K-02","K-05"]}' \
  "ready_by_class should group the serviceable boats by class"
tm_assert_output_jq needs_repair '. == ["K-03"]' "needs_repair should hold only the boats waiting for repair"
tm_assert_file_contains club/rota.txt "sea: K-02, K-05"
tm_assert_file_contains club/rota.txt "bench: K-03"

# Edit the register: a surf boat returns to service, K-03 is fixed, K-02 breaks.
cp club/fleet.json "$TM_TMP/fleet.orig"
trap 'cp "$TM_TMP/fleet.orig" club/fleet.json' EXIT
python3 - <<'PY'
import json, pathlib
p = pathlib.Path("club/fleet.json")
d = json.loads(p.read_text())
for b in d["fleet"]:
    if b["id"] == "K-06": b["status"] = "serviceable"
    if b["id"] == "K-03": b["status"] = "serviceable"
    if b["id"] == "K-02": b["status"] = "repair"
p.write_text(json.dumps(d))
PY
tm_apply
tm_assert_output_jq ready_by_class '. == {"river":["K-01","K-04"],"sea":["K-03","K-05"],"surf":["K-06"]}' \
  "ready_by_class did not follow the edited register"
tm_assert_output_jq needs_repair '. == ["K-02"]' "needs_repair did not follow the edited register"
tm_pass "the rota is filtered and grouped from the register"
