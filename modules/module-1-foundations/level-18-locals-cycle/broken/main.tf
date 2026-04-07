variable "base_name" {
  type    = string
  default = "myapp"
}

locals {
  full_name = "${local.prefix}-${var.base_name}"  # references local.prefix
  prefix    = "${local.full_name}-svc"            # references local.full_name → CYCLE
}

resource "local_file" "info" {
  content  = local.full_name
  filename = "${path.module}/info.txt"
}
