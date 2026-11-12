# Open Mic Inkwell poetry slam: seating and session times.
# Two rules tie variables together:
#   - the guest count must fit the tables (guests <= tables * seats_per_table)
#   - the session must end after it starts (end_hour > start_hour)
# Today the first rule is only enforced late, inside a resource, so a wrong answer is found
# after the plan has already started; the second rule is not enforced at all.

variable "guests" {
  type    = number
  default = 30

  validation {
    condition     = var.guests <= var.tables * var.seats_per_table
    error_message = "There are not enough seats (tables x seats_per_table) for the guests."
  }
}

variable "tables" {
  type    = number
  default = 5
}

variable "seats_per_table" {
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

  validation {
    condition     = var.end_hour > var.start_hour
    error_message = "The session must end after it starts."
  }
}

resource "local_file" "seating_plan" {
  filename = "${path.module}/slam/plan.txt"
  content  = "${var.guests} guests at ${var.tables} tables of ${var.seats_per_table}, ${var.start_hour}:00-${var.end_hour}:00\n"
}
