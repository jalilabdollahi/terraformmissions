resource "random_integer" "tension" {
  min = 3
  max = 12
}

output "turns" {
  value = random_integer.tension.result
}
