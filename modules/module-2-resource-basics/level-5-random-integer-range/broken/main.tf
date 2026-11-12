# Jackpot draw, Lucky Strike bingo hall.
# Jackpot cards are numbered 1000 to 1499 inclusive. Management draws one winner
# with Terraform so nobody can accuse the caller of peeking.

locals {
  first_card = 1000
  last_card  = 1499
}

resource "random_integer" "winning_card" {
  min = local.last_card
  max = local.first_card
}

resource "local_file" "announcement" {
  filename = "${path.module}/hall/winner.txt"
  content  = "Lucky Strike Bingo - winning card: ${random_integer.winning_card.result}\n"
}

output "winning_card" {
  value = random_integer.winning_card.result
}
