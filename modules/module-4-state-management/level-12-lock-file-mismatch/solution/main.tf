# Ember Lane coffee roastery: bean catalog reference generator.

resource "random_pet" "lot" {
  length    = 3
  separator = "-"
  prefix    = "rb"
}

resource "local_file" "bean_card" {
  filename = "${path.module}/catalog/card.txt"
  content  = "Lot ${random_pet.lot.id}: Ethiopian beans, 2 kg, sealed\n"
}

output "catalog_ref" {
  value = random_pet.lot.id
}
