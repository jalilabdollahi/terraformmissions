#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'validation[[:space:]]*\{' "the validation block must stay — it is the box office's safety net"

tm_apply
tm_assert_output section "ORC"
tm_assert_output seat_id "2041"
tm_assert_file_equals stubs/ORC-2041.txt "Section ORC, seat 2041
"

# It must accept other well-formed codes ...
tm_plan_json -var 'ticket_code=SYM-0007'
[[ "$(jq -r '.planned_values.outputs.section.value' "$TM_TMP/plan.json")" == "SYM" ]] \
  || tm_fail "a well-formed code (SYM-0007) was not accepted"

# ... and still reject badly shaped ones.
for bad in "orc-2041" "ORC2041" "ORCH-2041" "ORC-204" "ORC-20411" "xORC-2041" "ORC-2041x"; do
  if terraform plan -no-color -input=false -var "ticket_code=$bad" >"$TM_LAST_OUT" 2>&1; then
    tm_fail "the code '$bad' should be rejected by the validation but was accepted"
  fi
  grep -q "Ticket codes look like" "$TM_LAST_OUT" \
    || { tm_show_last; tm_fail "'$bad' failed, but not through the variable's own validation message"; }
done
tm_pass "ORC-2041 style codes are accepted, everything else is rejected by the validation"
