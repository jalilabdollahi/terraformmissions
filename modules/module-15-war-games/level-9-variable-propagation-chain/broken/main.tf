# BUG: module_a's variable is now named "token_length" but we're passing "token_size" here.
module "module_a" {
  source     = "./modules/module_a"
  token_size = 16
}

output "final_token" {
  value = module.module_a.token_result
}
