variable "log_path" {
  type = string
}

data "local_file" "ice_log" {
  filename = var.log_path
}

locals {
  thickness = tonumber(regex("thickness=([0-9]+)", data.local_file.ice_log.content)[0])
}

output "resurface_after_min" {
  value = local.thickness * 2
}
