# Ludlow Heritage Tree Preservation Office: tree register, one file per order.

variable "orders" {
  type = map(string)
  default = {
    "t-3011" = "Elm Lane oak no. 14: protection order granted, 2026-03-04, Desk 2"
    "t-3012" = "Marchbank Green beech: crown survey recorded, 2026-03-04, Desk 1"
    "t-3013" = "Orrin Mill yew: hedge-line boundary note, 2026-03-05, Desk 2"
    "t-3014" = "Pell Farm chestnut: root-zone fence order, 2026-03-06, Desk 3"
    "t-3015" = "Tidewater Park willow: felling licence refused, 2026-03-06, Desk 1"
  }
}

resource "local_file" "register" {
  for_each = var.orders
  filename = "${path.module}/register/${each.key}.txt"
  content  = "Tree ${each.key}: ${each.value}\n"
}

output "registered" {
  value = sort(keys(local_file.register))
}
