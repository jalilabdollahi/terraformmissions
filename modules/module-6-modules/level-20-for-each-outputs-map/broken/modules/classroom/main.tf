variable "style" {
  type = string
}

variable "students" {
  type = number
}

resource "terraform_data" "slot" {
  input = {
    room    = "${var.style}-room"
    minutes = var.students * 5
  }
}

output "minutes" {
  value = terraform_data.slot.input.minutes
}
