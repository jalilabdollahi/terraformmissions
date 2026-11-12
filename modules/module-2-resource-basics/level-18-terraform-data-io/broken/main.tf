# Ageing log for the Cedar Lane cigar humidor house.
# terraform_data holds a small record for each cigar batch so other resources
# can read it back; the log file is generated from that record.

variable "batch_code" {
  type    = string
  default = "CL-0412"
}

resource "terraform_data" "batch_record" {
  output = {
    batch  = var.batch_code
    boxes  = 36
    rested = false
  }

  triggers_replace = [var.batch_code]
}

resource "local_file" "humidor_log" {
  filename = "${path.module}/humidor/ageing.log"
  content  = "batch=${terraform_data.batch_record.result.batch} boxes=${terraform_data.batch_record.result.boxes}\n"
}

output "box_count" {
  value = terraform_data.batch_record.result.boxes
}
