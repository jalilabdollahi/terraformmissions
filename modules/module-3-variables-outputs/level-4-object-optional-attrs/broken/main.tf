# Frosty Spoon ice-cream parlour — menu export for the till system.

locals {
  menu = [
    for d in var.flavours : {
      name  = d.name
      price = d.price
      size  = d.size
    }
  ]
}

resource "local_file" "till_menu" {
  filename = "${path.module}/till/menu.json"
  content  = jsonencode({ parlour = var.parlour_name, items = local.menu })
}

output "menu" {
  value = local.menu
}
