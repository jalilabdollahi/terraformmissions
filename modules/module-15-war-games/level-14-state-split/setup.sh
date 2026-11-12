#!/usr/bin/env bash
source "$TM_LIB"
# The opera house has been running from a single state in monolith/. The three new stacks are scaffolded and initialised but empty.
cd "$WORKSPACE/monolith" || tm_fail "monolith/ missing"
tm_init "monolith init failed"
TM_MSG="monolith apply failed" tm_apply
tm_record hall_key "$(tm_state_attr random_id.hall_key hex)"
tm_record capacity "$(tm_state_attr random_integer.seat_capacity result)"
tm_record stage_main "$(tm_state_attr 'random_id.stage_serial["main"]' hex)"
tm_record stage_annex "$(tm_state_attr 'random_id.stage_serial["annex"]' hex)"
tm_record booking "$(tm_state_attr random_uuid.booking_ns result)"
tm_record gold "$(tm_state_attr 'random_integer.pass_series["gold"]' result)"
tm_record silver "$(tm_state_attr 'random_integer.pass_series["silver"]' result)"
tm_record ticket_book "$(tm_state_attr local_file.ticket_book id)"
tm_record stream_key "$(tm_state_attr random_id.cdn_key hex)"
tm_record enc_a "$(tm_state_attr 'terraform_data.encoder["a"]' id)"
tm_record enc_b "$(tm_state_attr 'terraform_data.encoder["b"]' id)"
tm_record playlist "$(tm_state_attr local_file.playlist id)"
for d in venue ticketing streaming; do
  cd "$WORKSPACE/$d" || tm_fail "$d/ missing"
  tm_init "$d init failed"
done
