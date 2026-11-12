# Duty cards for the Saltmarsh tugboat crews.
# crew maps each sailor's name to the role they hold this season.

resource "local_file" "duty_card" {
  for_each = var.crew
  filename = "${path.module}/cards/${each.key}.txt"
  content  = "Name: ${each.key}\nRole: ${each.value}\n"
}

output "cards_written" {
  value = length(local_file.duty_card)
}
