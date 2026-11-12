variable "estate" {
  type = string
}

variable "flush" {
  type = string
}

locals {
  grades = {
    first  = "FTGFOP1"
    second = "SFTGFOP"
    autumn = "TGFOP"
  }
}

resource "local_file" "label" {
  filename = "${path.root}/labels/${lower(var.estate)}-${var.flush}.txt"
  content  = "ESTATE ${upper(var.estate)}\nFLUSH ${var.flush}\nGRADE ${local.grades[var.flush]}\n"
}

output "label_path" {
  value = local_file.label.filename
}
