# Fairmount Park stadium: one tag file per seat, generated from the seating plan.

locals {
  stand_blocks = ["A", "B", "C", "D", "E", "F"]
  rows         = range(1, 6)
  seat_numbers = range(1, 11)

  seats = {
    for t in setproduct(local.stand_blocks, local.rows, local.seat_numbers) :
    "${lower(t[0])}-${t[1]}-${format("%02d", t[2])}" => {
      block = t[0]
      row   = t[1]
      seat  = format("%02d", t[2])
    }
  }
}

resource "local_file" "seat" {
  for_each = local.seats
  filename = "${path.module}/seats/${each.key}.txt"
  content  = "Block ${each.value.block}, row ${each.value.row}, seat ${each.value.seat}\n"
}

output "seat_total" {
  value = length(local_file.seat)
}
