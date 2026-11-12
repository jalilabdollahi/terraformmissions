# Maturing-room label for the Fenwick Lane cheese cellar.
local {
  cheese       = "Tomme de Fenwick"
  rind         = "washed"
  wheel_kg     = 8
  price_per_kg = 31
  wheel_price  = 8 * 31
}

resource "local_file" "wheel_label" {
  filename = "${path.module}/cellar/wheel-label.txt"
  content  = "${locals.cheese}\nRind: ${locals.rind}\nWeight: ${locals.wheel_kg} kg\nPrice: ${locals.wheel_price} EUR\n"
}

output "wheel_price" {
  value = locals.wheel_price
}
