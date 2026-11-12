# Cocktail Masterclass Bar: bench seating and class times.
# Two rules tie variables together:
#   - the student count must fit the benches (students <= benches * stools_per_bench)
#   - the class must end after it starts (end_hour > start_hour)
# Today the first rule is only enforced late, inside a resource, so a wrong answer is found
# after the plan has already started; the second rule is not enforced at all.

variable "students" {
  type    = number
  default = 30
}

variable "benches" {
  type    = number
  default = 5
}

variable "stools_per_bench" {
  type    = number
  default = 6
}

variable "start_hour" {
  type    = number
  default = 14
}

variable "end_hour" {
  type    = number
  default = 17
}

resource "local_file" "seating_plan" {
  filename = "${path.module}/class/plan.txt"
  content  = "${var.students} students at ${var.benches} benches of ${var.stools_per_bench}, ${var.start_hour}:00-${var.end_hour}:00\n"

  lifecycle {
    precondition {
      condition     = var.students <= var.benches * var.stools_per_bench
      error_message = "Not enough stools for the students."
    }
  }
}
