# Stock catalogue for the Thornfield hardware shop.
# The shop ledger id is the shop's permanent record and is protected from
# deletion. The shelf label is cosmetic: the shop just renamed its shelf
# prefix from "yard" to "depot", and the label is meant to follow.

resource "random_uuid" "ledger" {
  lifecycle {
    prevent_destroy = true
  }
}

resource "random_pet" "shelf_label" {
  prefix = "depot"
  length = 2

  lifecycle {
    prevent_destroy = true
  }
}

resource "local_file" "catalogue" {
  filename = "${path.module}/stock/catalogue.txt"
  content  = "ledger: ${random_uuid.ledger.result}\nshelf: ${random_pet.shelf_label.id}\n"
}

output "shelf_label" {
  value = random_pet.shelf_label.id
}
