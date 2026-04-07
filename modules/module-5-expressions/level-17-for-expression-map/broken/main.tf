variable "tags" {
  type = map(string)
  default = {
    env  = "production"
    team = "platform"
  }
}

# BUG: map-producing for expression uses comma instead of =>
locals {
  tag_map = {for k, v in var.tags : k, v}
}

output "tag_map" {
  value = local.tag_map
}
