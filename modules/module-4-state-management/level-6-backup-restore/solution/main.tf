# Redline Army-Surplus Store: surplus inventory list.
# An intern applied a branch without these three resources, then put the code back.
# Everything below is correct. Only the state lost the entries.

resource "random_pet" "store_manager" {
  length    = 2
  separator = " "
}

resource "random_string" "aisle_code" {
  length  = 6
  upper   = true
  lower   = false
  special = false
}

resource "random_integer" "lot_number" {
  min = 10000
  max = 99999
}

resource "local_file" "inventory_index" {
  filename = "${path.module}/inventory/index.txt"
  content  = <<-EOT
    Store manager: ${random_pet.store_manager.id}
    Aisle code: ${random_string.aisle_code.result}
    Next lot no: ${random_integer.lot_number.result}
  EOT
}
