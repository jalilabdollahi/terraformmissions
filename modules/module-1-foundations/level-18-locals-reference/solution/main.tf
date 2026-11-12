# Maturing-room label for the Fenwick Lane cheese cellar.
locals {
  cheese       = "Tomme de Fenwick"
  rind         = "washed"
  wheel_kg     = 8
  price_per_kg = 31
  wheel_price  = local.wheel_kg * local.price_per_kg
}

resource "local_file" "wheel_label" {
  filename = "${path.module}/cellar/wheel-label.txt"
  content  = "${local.cheese}\nRind: ${local.rind}\nWeight: ${local.wheel_kg} kg\nPrice: ${local.wheel_price} EUR\n"
}

output "wheel_price" {
  value = local.wheel_price
}
