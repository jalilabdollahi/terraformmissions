variable "env" {
  type     = string
  default  = null
  nullable = true
}

locals {
  env_lines = var.env != null ? ["env=${var.env}"] : []
  content   = join("\n", concat(["config:"], local.env_lines))
}

resource "local_file" "config" {
  content  = local.content
  filename = "${path.module}/config.txt"
}
