# Halcyon Opera House - the original single stack (to be split, see ../SPLIT-PLAN.md).

# --- venue ---
resource "random_id" "hall_key" {
  byte_length = 4
}

resource "random_integer" "seat_capacity" {
  min = 180
  max = 640
}

resource "random_id" "stage_serial" {
  for_each    = toset(["main", "annex"])
  byte_length = 3
}

# --- ticketing ---
resource "random_uuid" "booking_ns" {}

resource "random_integer" "pass_series" {
  for_each = toset(["gold", "silver"])
  min      = 10000
  max      = 99999
}

resource "local_file" "ticket_book" {
  filename = "${path.module}/../out/ticket-book.txt"
  content  = "booking ${random_uuid.booking_ns.result}\nhall ${random_id.hall_key.hex}\nseats ${random_integer.seat_capacity.result}\ngold ${random_integer.pass_series["gold"].result} silver ${random_integer.pass_series["silver"].result}\n"
}

# --- streaming ---
resource "random_id" "cdn_key" {
  byte_length = 6
}

resource "terraform_data" "encoder" {
  for_each = toset(["a", "b"])
  input    = "encoder-${each.key}"
}

resource "local_file" "playlist" {
  filename = "${path.module}/../out/playlist.txt"
  content  = "stream ${random_id.cdn_key.hex} hall ${random_id.hall_key.hex} gold ${random_integer.pass_series["gold"].result}\n"
}
