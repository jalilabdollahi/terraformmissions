resource "random_integer" "port" {
  min = 10
  max = 100
}

output "port" {
  value = random_integer.port.result
}
