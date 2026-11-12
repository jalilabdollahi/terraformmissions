# Question picker for the Friday pub quiz at The Gilded Heron.
variable "teams" {
  description = "How many teams registered tonight"
  type        = number
  default     = "eight"
}

resource "random_shuffle" "round_one" {
  input = [
    "Which planet has the shortest day?",
    "Who painted The Night Watch?",
    "What is the capital of Bhutan?",
    "How many strings has a standard violin?",
    "Which element has the symbol W?",
    "In which year did the Berlin Wall fall?",
    "What is the longest river in Europe?",
    "Who wrote Middlemarch?",
  ]
  result_count = "three"
}

resource "local_file" "question_sheet" {
  filename = "${path.module}/quiz/round-one.txt"
  content  = "Teams registered: ${var.teams}\n${join("\n", random_shuffle.round_one.result)}\n"
}

output "picked_questions" {
  value = random_shuffle.round_one.result
}

output "team_count" {
  value = var.teams
}
