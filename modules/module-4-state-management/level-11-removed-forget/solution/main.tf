# Lantern Lane night market.
# The permit book now belongs to the city clerk. The stall map stays ours.

resource "random_integer" "stall_count" {
  min = 40
  max = 80
}

resource "local_file" "stall_map" {
  filename = "${path.module}/market/stall-map.txt"
  content  = "Stalls open tonight: ${random_integer.stall_count.result}\n"
}

removed {
  from = local_file.permit_book

  lifecycle {
    destroy = false
  }
}
