# Maturation log for the Hollow Oak cheese cave.
# terraform_data holds a small record for each wheel batch so other resources
# can read it back; the log file is generated from that record.

variable "batch_code" {
  type    = string
  default = "HO-0412"
}

resource "terraform_data" "batch_record" {
  output = {
    batch   = var.batch_code
    wheels  = 36
    ripened = false
  }

  triggers_replace = [var.batch_code]
}

resource "local_file" "cave_log" {
  filename = "${path.module}/cave/maturation.log"
  content  = "batch=${terraform_data.batch_record.result.batch} wheels=${terraform_data.batch_record.result.wheels}\n"
}

output "wheel_count" {
  value = terraform_data.batch_record.result.wheels
}
