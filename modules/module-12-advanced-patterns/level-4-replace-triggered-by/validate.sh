#!/usr/bin/env bash
source "$TM_LIB"

CAB=$(tm_recall cabinet_id); CAL=$(tm_recall cal_id); FW=$(tm_recall fw_id)
[[ -n "$CAB" && -n "$CAL" && -n "$FW" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

TRIG=$(python3 - <<'PY'
import glob, re
text = "\n".join(open(f).read() for f in glob.glob("*.tf"))
text = re.sub(r"#.*", "", text)
m = re.search(r"replace_triggered_by\s*=\s*\[([^\]]*)\]", text)
print(re.sub(r"\s+", " ", m.group(1)) if m else "NONE")
PY
)
[[ "$TRIG" != "NONE" ]] || tm_fail "the cabinet needs a replace_triggered_by rule"
grep -q 'firmware_pack' <<<"$TRIG" || tm_fail "replace_triggered_by must watch the firmware pack"
grep -q 'calibration' <<<"$TRIG" && tm_fail "calibration must not trigger a rebuild of the cabinet"

tm_apply

NOW_CAB=$(tm_state_attr terraform_data.cabinet id)
[[ -n "$NOW_CAB" && "$NOW_CAB" != "$CAB" ]] || tm_fail "the cabinet record was not rebuilt after the firmware change (ID still $CAB)"
[[ "$(tm_state_attr terraform_data.calibration id)" == "$CAL" ]] || tm_fail "the calibration record was rebuilt, it should be left alone"
[[ "$(tm_state_attr terraform_data.firmware_pack id)" == "$FW" ]] || tm_fail "the firmware pack record was rebuilt; it should only be updated in place"
[[ "$(tm_state_attr terraform_data.firmware_pack output)" == "3.2" ]] || tm_fail "the firmware pack should now be at 3.2"

tm_assert_file_equals service/pb-114.txt "cabinet ${NOW_CAB} runs firmware 3.2"$'\n'
tm_assert_no_changes
tm_pass "the cabinet was rebuilt by the firmware change and calibration was left untouched"
