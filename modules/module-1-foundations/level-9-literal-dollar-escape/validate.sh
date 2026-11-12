#!/usr/bin/env bash
source "$TM_LIB"

tm_validate "terraform is still trying to evaluate the shell variables as Terraform expressions"
tm_apply
expected=$'#!/usr/bin/env bash\n# Watering routine for tomato-bay\nPUMP_LOG="${HOME}/greenhouse/pump.log"\nsleep "${PUMP_SECONDS:-30}"\necho "watered tomato-bay" >> "$PUMP_LOG"\n'
tm_assert_file_equals dome3/water.sh "$expected" "dome3/water.sh does not have the expected content"
if ! bash -n dome3/water.sh 2>"$TM_TMP/bash.err"; then
  tm_fail "dome3/water.sh is not valid bash"
fi
[[ -x dome3/water.sh ]] || tm_fail "dome3/water.sh should stay executable (0755)"
# the bay name must still come from the variable
tm_apply -var 'bay=pepper-bay'
tm_assert_file_contains dome3/water.sh 'echo "watered pepper-bay"' "the bay name should come from var.bay"
tm_assert_file_contains dome3/water.sh '${PUMP_SECONDS:-30}' "the shell default expression must be written literally"
tm_apply
tm_assert_no_changes
tm_pass "Terraform filled the bay name and left the shell expressions alone"
