variable "enabled" {
  type    = bool
  default = true
}

module "mymod" {
  count  = var.enabled ? 1 : 0
  source = "./modules/mymod"
}

output "result_path" {
  value = try(module.mymod[0].file_path, "")
}
