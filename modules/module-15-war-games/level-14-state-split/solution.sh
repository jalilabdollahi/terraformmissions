#!/usr/bin/env bash
source "$TM_LIB"
# monolith/*.tf is removed and ticketing gains its gold_series output through the solution overlay.
SRC="$WORKSPACE/monolith/terraform.tfstate"
move() { # <stack> <old address> <new address>
  terraform state mv -state="$SRC" -state-out="$WORKSPACE/$1/terraform.tfstate" "$2" "$3" || exit 1
}
cd "$WORKSPACE" || exit 1
move venue random_id.hall_key random_id.hall_key
move venue random_integer.seat_capacity random_integer.seat_capacity
move venue random_id.stage_serial random_id.stage_serial
move ticketing random_uuid.booking_ns random_uuid.booking_ns
move ticketing random_integer.pass_series random_integer.pass_series
move ticketing local_file.ticket_book local_file.ticket_book
move streaming random_id.cdn_key random_id.stream_key
move streaming terraform_data.encoder terraform_data.encoder
move streaming local_file.playlist local_file.playlist
for d in venue ticketing streaming; do
  (cd "$WORKSPACE/$d" && terraform apply -auto-approve) || exit 1
done
