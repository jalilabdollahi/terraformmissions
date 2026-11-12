# Silver Halide film lab - developing run for batch 114.

variable "bath_temp_c" {
  description = "Developer bath temperature in whole degrees Celsius."
  type        = number
  default     = 20
}

resource "terraform_data" "develop_batch" {
  input = "batch-114"

  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/develop.sh batch-114 ${var.bath_temp_c}"
  }
}

output "batch" {
  value = terraform_data.develop_batch.output
}
