variable "farm" {
  type = string
}

variable "clip" {
  type = string
}

locals {
  grades = {
    spring = "SUPER70"
    summer = "FINE64"
    autumn = "MEDIUM58"
  }
}

resource "local_file" "label" {
  filename = "${path.root}/labels/${lower(var.farm)}-${var.clip}.txt"
  content  = "FARM ${upper(var.farm)}\nCLIP ${var.clip}\nGRADE ${local.grades[var.clip]}\n"
}

output "label_path" {
  value = local_file.label.filename
}
