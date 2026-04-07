variable "envs" {
  type    = set(string)
  default = ["dev", "prod"]
}

resource "local_file" "configs" {
  for_each = var.envs
  content  = "env=${each.key}"
  filename = "${path.module}/config-${each.key}.txt"
}

output "config_paths" {
  value = { for k, v in local_file.configs : k => v.filename }
}
