resource "random_id" "generator_serial" {
  byte_length = 4
}

resource "random_integer" "fuel_litres" {
  min = 200
  max = 900
}

output "generator_id" {
  value = random_id.generator_serial.hex
}

output "fuel" {
  value = random_integer.fuel_litres.result
}
