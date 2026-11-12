# Pressed & Proper dry-cleaning plant - cleaning run for batch 114.

variable "wash_temp_c" {
  description = "Solvent wash temperature in whole degrees Celsius."
  type        = number
  default     = 20
}

resource "terraform_data" "clean_batch" {
  input = "batch-114"

  provisioner "local-exec" {
    command    = "bash ${path.module}/scripts/clean.sh batch-114 ${var.wash_temp_c}C"
    on_failure = continue
  }
}

output "batch" {
  value = terraform_data.clean_batch.output
}
