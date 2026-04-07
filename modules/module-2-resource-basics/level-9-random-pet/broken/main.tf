# BUG: separator expects a string, not a number.

resource "random_pet" "server_name" {
  length    = 2
  separator = 123
}

output "server_name" {
  value = random_pet.server_name.id
}
