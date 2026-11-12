#!/usr/bin/env bash
source "$TM_LIB"

validations=$(grep -c 'validation[[:space:]]*{' modules/billing/main.tf 2>/dev/null)
[[ "${validations:-0}" -ge 2 ]] || tm_fail "the module's validation blocks must stay — the fix belongs in the caller"
tm_assert_config_has 'regex\("\^\[A-Z\]\{3\}-\[0-9\]\{2\}\$"' "the show_code check must keep its pattern"

tm_init
TM_MSG="terraform apply failed — the module's validation messages say what it expects from the caller" tm_apply
tm_assert_output programme "SOR-07 | doors 60 min before curtain"

tm_apply -var run_no=12
tm_assert_output programme "SOR-12 | doors 60 min before curtain"
tm_apply -var act=dove -var doors_open_hours=0.5
tm_assert_output programme "DOV-07 | doors 30 min before curtain"

# Out-of-range input must still be refused by the module itself
code=$(tm_plan_code -var doors_open_hours=2)
[[ "$code" == "1" ]] || tm_fail "two hours of doors-open time was accepted — the module's validation must keep rejecting it"
grep -q "doors_open_min must be between 15 and 90" "$TM_LAST_OUT" \
  || tm_fail "the rejection did not come from the module's own validation message"

tm_apply
tm_assert_no_changes
tm_pass "the caller now speaks the module's language and validation still guards the door"
