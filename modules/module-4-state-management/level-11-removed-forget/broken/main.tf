# Lantern Lane night market.
# The permit book is moving to the city clerk's system. The stall map stays ours.

resource "random_integer" "stall_count" {
  min = 40
  max = 80
}

resource "local_file" "stall_map" {
  filename = "${path.module}/market/stall-map.txt"
  content  = "Stalls open tonight: ${random_integer.stall_count.result}\n"
}

resource "local_file" "permit_book" {
  filename = "${path.module}/permits/permit-book.txt"
  content  = "Permit 0001 - noodles - cleared\nPermit 0002 - lanterns - cleared\n"
}
