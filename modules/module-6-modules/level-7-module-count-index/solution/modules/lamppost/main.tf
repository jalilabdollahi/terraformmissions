variable "number" {
  type = number
}

resource "terraform_data" "lamp" {
  input = format("LP-%02d", var.number)
}

output "label" {
  value = terraform_data.lamp.output
}
