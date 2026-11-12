resource "random_integer" "dose" {
  min = 3
  max = 12
}

output "scoops" {
  value = random_integer.dose.result
}
