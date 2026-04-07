variable "base_name" {
  type    = string
  default = "myapp"
}

locals {
  prefix    = "svc"
  full_name = "${local.prefix}-${var.base_name}"
}

resource "local_file" "info" {
  content  = local.full_name
  filename = "${path.module}/info.txt"
}
