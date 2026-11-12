#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"local_file"' "the register must still be read through a local_file data source"
if grep -qE 'T-0[0-9]' main.tf; then tm_fail "tool ids must come from the register, not from the config"; fi

tm_apply
tm_assert_output_jq ready_by_class '. == {"garden":["T-01","T-04"],"power":["T-02","T-05"]}' \
  "ready_by_class should group the serviceable tools by class"
tm_assert_output_jq needs_repair '. == ["T-03"]' "needs_repair should hold only the tools waiting for repair"
tm_assert_file_contains library/rota.txt "power: T-02, T-05"
tm_assert_file_contains library/rota.txt "mending: T-03"

# Edit the register: a decor tool returns to service, T-03 is fixed, T-02 breaks.
cp library/stock.json "$TM_TMP/stock.orig"
trap 'cp "$TM_TMP/stock.orig" library/stock.json' EXIT
python3 - <<'PY'
import json, pathlib
p = pathlib.Path("library/stock.json")
d = json.loads(p.read_text())
for b in d["stock"]:
    if b["id"] == "T-06": b["status"] = "serviceable"
    if b["id"] == "T-03": b["status"] = "serviceable"
    if b["id"] == "T-02": b["status"] = "repair"
p.write_text(json.dumps(d))
PY
tm_apply
tm_assert_output_jq ready_by_class '. == {"garden":["T-01","T-04"],"power":["T-03","T-05"],"decor":["T-06"]}' \
  "ready_by_class did not follow the edited register"
tm_assert_output_jq needs_repair '. == ["T-02"]' "needs_repair did not follow the edited register"
tm_pass "the rota is filtered and grouped from the register"
