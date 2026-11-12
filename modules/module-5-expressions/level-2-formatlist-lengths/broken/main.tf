# Ashdown Steam Fair Showground gate office — one printed price line per ticket type.
# Every line carries the same currency code, which comes from a single variable.

variable "tiers" {
  type    = list(string)
  default = ["Weekend Pass", "Day Ticket", "Evening Entry"]
}

variable "prices" {
  type    = list(number)
  default = [45, 30, 18.5]
}

variable "currency" {
  type    = string
  default = "GBP"
}

locals {
  price_lines = formatlist("%s — %s %.2f", var.tiers, ["GBP", "GBP"], var.prices)
}

resource "local_file" "price_board" {
  filename = "${path.module}/board/prices.txt"
  content  = "${join("\n", local.price_lines)}\n"
}

output "price_lines" {
  value = local.price_lines
}
