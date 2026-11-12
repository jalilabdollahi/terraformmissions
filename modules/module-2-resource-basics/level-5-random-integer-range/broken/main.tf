# Harvest Fair raffle, Ashby village hall.
# Tickets are numbered 1000 to 1499 inclusive. The committee draws one winner
# with Terraform so nobody can accuse the chairman of peeking.

locals {
  first_ticket = 1000
  last_ticket  = 1499
}

resource "random_integer" "winning_ticket" {
  min = local.last_ticket
  max = local.first_ticket
}

resource "local_file" "announcement" {
  filename = "${path.module}/hall/winner.txt"
  content  = "Ashby Harvest Fair - winning ticket: ${random_integer.winning_ticket.result}\n"
}

output "winning_ticket" {
  value = random_integer.winning_ticket.result
}
