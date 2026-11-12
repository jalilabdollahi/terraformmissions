# Duty cards for the Marlowe Pier ride crews.
# crew maps each operator's name to the role they hold this season.

resource "local_file" "duty_card" {
  for_each = var.crew
  filename = "${path.module}/cards/${each.value}.txt"
  content  = "Name: ${each.value}\nRole: ${each.key}\n"
}

output "cards_written" {
  value = length(local_file.duty_card)
}
