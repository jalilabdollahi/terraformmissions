# Quill & Kettle café — menu export for the till system.

locals {
  menu = [
    for d in var.drinks : {
      name  = d.name
      price = d.price
      size  = d.size
    }
  ]
}

resource "local_file" "till_menu" {
  filename = "${path.module}/till/menu.json"
  content  = jsonencode({ cafe = var.cafe_name, items = local.menu })
}

output "menu" {
  value = local.menu
}
