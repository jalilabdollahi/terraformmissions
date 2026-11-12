# Seed vault catalogue for the Thornfield community seed library.
# The vault ledger id is the library's permanent record and is protected from
# deletion. The shelf label is cosmetic: the library just renamed its shelf
# prefix from "attic" to "bunker", and the label is meant to follow.

resource "random_uuid" "ledger" {
  lifecycle {
    prevent_destroy = true
  }
}

resource "random_pet" "shelf_label" {
  prefix = "bunker"
  length = 2

  lifecycle {
    prevent_destroy = true
  }
}

resource "local_file" "catalogue" {
  filename = "${path.module}/vault/catalogue.txt"
  content  = "ledger: ${random_uuid.ledger.result}\nshelf: ${random_pet.shelf_label.id}\n"
}

output "shelf_label" {
  value = random_pet.shelf_label.id
}
