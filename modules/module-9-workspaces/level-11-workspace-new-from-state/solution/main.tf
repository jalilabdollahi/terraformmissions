# Bramble Lane jam kitchen: seasonal batch codename and its jar label card.

resource "random_pet" "batch" {
  length    = 2
  prefix    = "plum"
  separator = "-"
}

resource "local_file" "batch_card" {
  filename = "${path.module}/out/batch-card.txt"
  content  = "Seasonal batch: ${random_pet.batch.id}\n"
}

output "batch_name" {
  value = random_pet.batch.id
}
