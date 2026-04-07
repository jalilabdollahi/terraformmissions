resource "random_pet" "server_name" {
  length    = 2
  separator = "-"
}

output "server_name" {
  value = random_pet.server_name.id
}
