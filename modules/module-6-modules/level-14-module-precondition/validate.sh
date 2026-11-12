#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'precondition[[:space:]]*\{' "the module's guard must stay as a precondition"
tm_assert_config_has 'Basket overloaded' "keep the module's error message so callers recognise the rejection"

# Each row: class passengers expected(ok|reject)
check_booking() {
  local cls="$1" pax="$2" want="$3" code
  code=$(tm_plan_code -var "flight_class=$cls" -var "passengers=$pax")
  if [[ "$want" == "ok" ]]; then
    [[ "$code" == "0" || "$code" == "2" ]] \
      || { tm_show_last; tm_fail "a $cls flight with $pax passengers is legal but the module refuses it"; }
  else
    [[ "$code" == "1" ]] || tm_fail "a $cls flight with $pax passengers is over the limit but the module accepts it"
    grep -q "Basket overloaded\|at least one passenger" "$TM_LAST_OUT" \
      || tm_fail "the $cls/$pax rejection did not come from the module's precondition"
  fi
}

tm_init
check_booking standard 10 ok
check_booking sunrise 8 ok
check_booking sunrise 9 reject
check_booking sunrise 12 reject
check_booking standard 12 ok
check_booking standard 13 reject
check_booking standard 0 reject
check_booking sunrise 1 ok

TM_MSG="the default booking (standard, 10) must apply" tm_apply
tm_assert_in_state module.booking.terraform_data.basket
tm_assert_file_equals manifest.txt $'standard flight: 10 passengers\n'
tm_assert_output summary "standard flight: 10 passengers"

tm_apply -var flight_class=sunrise -var passengers=6
tm_assert_file_equals manifest.txt $'sunrise flight: 6 passengers\n'

tm_apply
tm_assert_no_changes
tm_pass "the module's guard now accepts exactly the legal bookings"
