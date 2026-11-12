# Svalbard seed vault: catalog reference generator.

resource "random_pet" "accession" {
  length    = 3
  separator = "-"
  prefix    = "sv"
}

resource "local_file" "catalog_card" {
  filename = "${path.module}/catalog/card.txt"
  content  = "Accession ${random_pet.accession.id}: barley, 2 kg, sealed\n"
}

output "catalog_ref" {
  value = random_pet.accession.id
}
