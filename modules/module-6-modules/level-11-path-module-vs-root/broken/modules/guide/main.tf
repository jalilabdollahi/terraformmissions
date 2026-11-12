variable "exhibit" {
  type = string
}

variable "narrator" {
  type = string
}

locals {
  script = templatefile("${path.root}/templates/narration.tpl", {
    exhibit  = replace(var.exhibit, "-", " ")
    narrator = var.narrator
  })
}

resource "local_file" "script" {
  filename = "${path.module}/audio/${var.exhibit}.txt"
  content  = local.script
}

output "script_path" {
  value = local_file.script.filename
}
