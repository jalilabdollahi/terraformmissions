variable "stop" {
  type = string
}

variable "narrator" {
  type = string
}

locals {
  script = templatefile("${path.root}/templates/narration.tpl", {
    stop     = replace(var.stop, "-", " ")
    narrator = var.narrator
  })
}

resource "local_file" "script" {
  filename = "${path.module}/audio/${var.stop}.txt"
  content  = local.script
}

output "script_path" {
  value = local_file.script.filename
}
