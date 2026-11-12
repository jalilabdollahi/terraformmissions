# Alder Street Library: card catalog.
# An intern applied a branch without these three resources, then put the code back.
# Everything below is correct. Only the state lost the entries.

resource "random_pet" "head_librarian" {
  length    = 2
  separator = " "
}

resource "random_string" "shelf_code" {
  length  = 6
  upper   = true
  lower   = false
  special = false
}

resource "random_integer" "card_number" {
  min = 10000
  max = 99999
}

resource "local_file" "catalog_index" {
  filename = "${path.module}/catalog/index.txt"
  content  = <<-EOT
    Head librarian: ${random_pet.head_librarian.id}
    Shelf code: ${random_string.shelf_code.result}
    Next card: ${random_integer.card_number.result}
  EOT
}
