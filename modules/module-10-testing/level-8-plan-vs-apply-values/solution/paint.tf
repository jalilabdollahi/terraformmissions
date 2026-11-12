variable "white_parts" {
  description = "Parts of white base in the mix."
  type        = number
  default     = 3
}

variable "base_parts" {
  description = "Parts of coloured base in the mix."
  type        = number
  default     = 2
}

resource "random_id" "batch" {
  byte_length = 4
}

resource "random_integer" "tint" {
  min = 10
  max = 99
}

output "ratio_label" {
  value = "${var.white_parts}:${var.base_parts}"
}

output "batch_code" {
  value = "PB-${upper(random_id.batch.hex)}"
}

output "tint_number" {
  value = random_integer.tint.result
}
