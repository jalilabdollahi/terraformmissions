# Question picker for the Saturday-night TV game show Buzzer Row.
variable "contestants" {
  description = "How many contestants are on set tonight"
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

resource "local_file" "question_cards" {
  filename = "${path.module}/studio/round-one.txt"
  content  = "Contestants on set: ${var.contestants}\n${join("\n", random_shuffle.round_one.result)}\n"
}

output "picked_questions" {
  value = random_shuffle.round_one.result
}

output "contestant_count" {
  value = var.contestants
}
