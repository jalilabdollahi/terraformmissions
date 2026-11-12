#!/usr/bin/env bash
source "$TM_LIB"

CTRL=$(tm_recall controller_id); CAL=$(tm_recall cal_id); FW=$(tm_recall fw_id)
[[ -n "$CTRL" && -n "$CAL" && -n "$FW" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

TRIG=$(python3 - <<'PY'
import glob, re
text = "\n".join(open(f).read() for f in glob.glob("*.tf"))
text = re.sub(r"#.*", "", text)
m = re.search(r"replace_triggered_by\s*=\s*\[([^\]]*)\]", text)
print(re.sub(r"\s+", " ", m.group(1)) if m else "NONE")
PY
)
[[ "$TRIG" != "NONE" ]] || tm_fail "the controller needs a replace_triggered_by rule"
grep -q 'firmware_pack' <<<"$TRIG" || tm_fail "replace_triggered_by must watch the firmware pack"
grep -q 'calibration' <<<"$TRIG" && tm_fail "calibration must not trigger a rebuild of the controller"

tm_apply

NOW_CTRL=$(tm_state_attr terraform_data.controller id)
[[ -n "$NOW_CTRL" && "$NOW_CTRL" != "$CTRL" ]] || tm_fail "the controller record was not rebuilt after the firmware change (ID still $CTRL)"
[[ "$(tm_state_attr terraform_data.calibration id)" == "$CAL" ]] || tm_fail "the calibration record was rebuilt, it should be left alone"
[[ "$(tm_state_attr terraform_data.firmware_pack id)" == "$FW" ]] || tm_fail "the firmware pack record was rebuilt; it should only be updated in place"
[[ "$(tm_state_attr terraform_data.firmware_pack output)" == "3.2" ]] || tm_fail "the firmware pack should now be at 3.2"

tm_assert_file_equals service/gt-114.txt "controller ${NOW_CTRL} runs firmware 3.2"$'\n'
tm_assert_no_changes
tm_pass "the controller was rebuilt by the firmware change and calibration was left untouched"
