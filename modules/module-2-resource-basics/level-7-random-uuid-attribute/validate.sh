#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "random_uuid" "drop_id"' "random_uuid.drop_id must stay"
tm_assert_config_has 'resource "random_uuid" "receipt_id"' "random_uuid.receipt_id must stay"
tm_apply
CODE=$(tm_output_raw pickup_code) || tm_fail "output pickup_code is missing"
UUID_RE='^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
[[ "$CODE" =~ $UUID_RE ]] || tm_fail "pickup_code '$CODE' is not a UUID"
[[ "$CODE" == "$(tm_state_attr random_uuid.drop_id result)" ]] || tm_fail "pickup_code is not the drop_id UUID from state"
RECEIPT=$(tm_state_attr random_uuid.receipt_id result)
[[ "$(jq -r .drop_id lockers/ticket.json 2>/dev/null)" == "$CODE" ]] || tm_fail "ticket.json drop_id does not match the generated UUID"
[[ "$(jq -r .receipt lockers/ticket.json 2>/dev/null)" == "$RECEIPT" ]] || tm_fail "ticket.json receipt does not match random_uuid.receipt_id"
[[ "$(jq -r .locker lockers/ticket.json)" == "B-14" ]] || tm_fail "ticket.json lost the locker number"
tm_assert_no_changes
tm_pass "ticket and pickup code carry the generated UUIDs"
