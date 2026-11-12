# Pressed & Proper Bookbindery - binding run for batch 114.

variable "press_temp_c" {
  description = "Heated-press temperature in whole degrees Celsius."
  type        = number
  default     = 20
}

resource "terraform_data" "bind_batch" {
  input = "batch-114"

  provisioner "local-exec" {
    command    = "bash ${path.module}/scripts/bind.sh batch-114 ${var.press_temp_c}C"
    on_failure = continue
  }
}

output "batch" {
  value = terraform_data.bind_batch.output
}
