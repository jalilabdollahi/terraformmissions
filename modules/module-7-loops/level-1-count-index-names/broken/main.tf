# Clue cards for the "Clockmaker's Cellar" escape room.
# One printed card per clue, numbered from the first clue (0) upwards.

resource "local_file" "clue_card" {
  count    = length(var.clues)
  filename = "${path.module}/cards/clue.txt"
  content  = "CLUE: ${var.clues[count.index]}\n"
}

output "card_files" {
  value = local_file.clue_card[*].filename
}
