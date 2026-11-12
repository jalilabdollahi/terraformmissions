# Summer fête tombola: draw the winning ticket and print it for the stage board.
resource "random_integer" "winning_ticket" {
  min = 100
  max = 499
}

resource "local_file" "stage_board" {
  filename = "${path.module}/fete/stage-board.txt"
  content  = "Winning ticket: ${random_integer.winning_ticket.result}\n"
}

output "winning_ticket" {
  value = random_integer.winning_ticket.result
}
