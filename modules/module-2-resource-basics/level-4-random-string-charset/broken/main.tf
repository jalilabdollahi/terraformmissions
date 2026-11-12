# Library card numbers for the Marlowe Street branch library.
# Rule from the circulation desk's scanner: a card number is exactly 10 characters,
# lowercase letters and digits only (no capitals, no punctuation).

resource "random_string" "card_number" {
  length = 16
}

resource "local_file" "new_member_card" {
  filename = "${path.module}/cards/new-member.txt"
  content  = <<-EOT
    MARLOWE STREET LIBRARY
    Card no: ${random_string.card_number.result}
    Loan period: 21 days
  EOT
}

output "card_number" {
  value = random_string.card_number.result
}
