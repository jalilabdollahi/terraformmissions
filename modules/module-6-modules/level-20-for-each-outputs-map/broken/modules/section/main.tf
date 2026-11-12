variable "voice" {
  type = string
}

variable "singers" {
  type = number
}

resource "terraform_data" "slot" {
  input = {
    room    = "${var.voice}-room"
    minutes = var.singers * 5
  }
}

output "minutes" {
  value = terraform_data.slot.input.minutes
}
