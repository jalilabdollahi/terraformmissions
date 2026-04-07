# BUG: min (100) is greater than max (10), which is logically impossible.

resource "random_integer" "port" {
  min = 100
  max = 10
}

output "port" {
  value = random_integer.port.result
}
