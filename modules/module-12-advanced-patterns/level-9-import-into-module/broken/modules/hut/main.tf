variable "name" {
  type = string
}

resource "random_pet" "mascot" {
  length = 2
  prefix = var.name
}

resource "random_id" "key" {
  byte_length = 4
}

resource "local_file" "keyring" {
  filename = "${path.root}/huts/${var.name}.txt"
  content  = "hut ${var.name} (${random_pet.mascot.id}) key ${random_id.key.hex}\n"
}

output "key_hex" {
  value = random_id.key.hex
}
