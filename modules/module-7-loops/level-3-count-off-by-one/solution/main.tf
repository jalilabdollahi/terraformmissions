# Bay signs for the Quayside multi-storey car park.
# Drivers see "Bay 1" ... "Bay N": nobody parks in bay zero.

resource "local_file" "bay_sign" {
  count    = var.bays
  filename = "${path.module}/signs/${format("bay-%02d", count.index + 1)}.txt"
  content  = "BAY ${count.index + 1} of ${var.bays}\n"
}

output "last_sign" {
  value = local_file.bay_sign[var.bays - 1].filename
}
