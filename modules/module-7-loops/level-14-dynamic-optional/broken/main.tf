variable "env" {
  type     = string
  default  = null
  # nullable = false means this variable can never be null — contradicts default = null
  nullable = false
}

locals {
  env_lines = var.env != null ? ["env=${var.env}"] : []
  content   = join("\n", concat(["config:"], local.env_lines))
}

resource "local_file" "config" {
  content  = local.content
  filename = "${path.module}/config.txt"
}
