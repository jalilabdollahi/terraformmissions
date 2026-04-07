module "module_a" {
  source       = "./modules/module_a"
  token_length = 16
}

output "final_token" {
  value = module.module_a.token_result
}
