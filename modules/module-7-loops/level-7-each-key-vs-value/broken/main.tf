# Duty cards for the Saltmarsh tugboat crews.
# crew maps each sailor's name to the role they hold this season.

resource "local_file" "duty_card" {
  for_each = var.crew
  filename = "${path.module}/cards/${each.value}.txt"
  content  = "Name: ${each.value}\nRole: ${each.key}\n"
}

output "cards_written" {
  value = length(local_file.duty_card)
}
