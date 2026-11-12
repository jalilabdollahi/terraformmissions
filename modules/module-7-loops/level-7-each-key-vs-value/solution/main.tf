# Duty cards for the Marlowe Pier ride crews.
# crew maps each operator's name to the role they hold this season.

resource "local_file" "duty_card" {
  for_each = var.crew
  filename = "${path.module}/cards/${each.key}.txt"
  content  = "Name: ${each.key}\nRole: ${each.value}\n"
}

output "cards_written" {
  value = length(local_file.duty_card)
}
