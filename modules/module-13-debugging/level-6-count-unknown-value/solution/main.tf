# Ember & Ash hot-sauce lab - blind tasting cards.

variable "panel_size" {
  description = "How many flavours go on this week's tasting panel."
  type        = number
  default     = 3
}

resource "random_shuffle" "panel" {
  input        = ["habanero", "ghost pepper", "chipotle", "smoked paprika", "scotch bonnet"]
  result_count = var.panel_size
}

# One printed card per flavour on the panel.
resource "local_file" "tasting_card" {
  count    = var.panel_size
  filename = "${path.module}/cards/card-${count.index + 1}.txt"
  content  = "Blind tasting #${count.index + 1}: ${random_shuffle.panel.result[count.index]}\n"
}

output "card_files" {
  value = local_file.tasting_card[*].filename
}
