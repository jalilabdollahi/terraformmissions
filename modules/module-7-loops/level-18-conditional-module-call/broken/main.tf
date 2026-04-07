variable "enabled" {
  type    = bool
  default = true
}

module "mymod" {
  count  = var.enabled ? 1 : 0
  source = "./modules/mymod"
}

# Wrong: count module must be addressed with [0], not as a singleton
output "result_path" {
  value = module.mymod.file_path
}
