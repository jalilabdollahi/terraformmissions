module "module_b" {
  source       = "../module_b"
  token_length = var.token_length
}

output "token_result" {
  value = module.module_b.generated_token
}
