#!/usr/bin/env bash
source "$TM_LIB"

[[ -n "$(tm_recall hall_key)" && -n "$(tm_recall playlist)" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"

tm_assert_config_has 'terraform_remote_state' "the stacks must share values through terraform_remote_state"
for k in hall_key capacity stream_key booking; do
  tm_assert_config_lacks "$(tm_recall $k)" "an identifier is typed into the code - values must flow through state"
done
if ls monolith/*.tf >/dev/null 2>&1; then
  grep -qE '^[[:space:]]*(resource|data|module)[[:space:]]' monolith/*.tf && tm_fail "monolith/ still contains resource code - it must be emptied"
fi
if [[ -f monolith/terraform.tfstate ]]; then
  [[ "$(jq '.resources | length' monolith/terraform.tfstate)" == "0" ]] || tm_fail "monolith/terraform.tfstate still tracks objects - every object must live in exactly one new stack"
fi

managed_count() { local l; l=$(tm_state_list); grep -vc "^data\\." <<<"$l"; }
stack() { cd "$WORKSPACE/$1" 2>/dev/null || tm_fail "stack $1/ is missing"; tm_init "init failed in $1/"; }
want() { # <stack> <address> <attribute> <recall key> <what>
  tm_assert_in_state "$2" "$5 is not in the $1 state"
  [[ "$(tm_state_attr "$2" "$3")" == "$(tm_recall "$4")" ]] || tm_fail "$5 in $1 was re-issued: its value is not the opera house's original"
}

stack venue
want venue random_id.hall_key hex hall_key "the hall key"
want venue random_integer.seat_capacity result capacity "the seat capacity"
want venue 'random_id.stage_serial["main"]' hex stage_main "the main stage serial"
want venue 'random_id.stage_serial["annex"]' hex stage_annex "the annex stage serial"
[[ "$(managed_count)" == "4" ]] || tm_fail "venue should hold exactly 4 objects, found $(managed_count)"
tm_assert_no_destroy
TM_MSG="venue plan is not clean (are its outputs published?)" tm_assert_no_changes

stack ticketing
want ticketing random_uuid.booking_ns result booking "the booking namespace"
want ticketing 'random_integer.pass_series["gold"]' result gold "the gold pass series"
want ticketing 'random_integer.pass_series["silver"]' result silver "the silver pass series"
want ticketing local_file.ticket_book id ticket_book "the ticket book"
[[ "$(managed_count)" == "4" ]] || tm_fail "ticketing should hold exactly 4 objects, found $(managed_count)"
tm_assert_no_destroy
TM_MSG="ticketing plan is not clean" tm_assert_no_changes

stack streaming
want streaming random_id.stream_key hex stream_key "the stream key"
want streaming 'terraform_data.encoder["a"]' id enc_a "encoder a"
want streaming 'terraform_data.encoder["b"]' id enc_b "encoder b"
want streaming local_file.playlist id playlist "the playlist"
tm_assert_not_in_state random_id.cdn_key "random_id.cdn_key should have been renamed to stream_key"
tm_assert_no_destroy
TM_MSG="streaming plan is not clean" tm_assert_no_changes

cd "$WORKSPACE" || exit 1
tm_assert_file_contains out/ticket-book.txt "hall $(tm_recall hall_key)" "the ticket book changed"
tm_assert_file_contains out/playlist.txt "gold $(tm_recall gold)" "the playlist changed"
tm_pass "three stacks own their objects with original identities, monolith is empty, all plans clean"
