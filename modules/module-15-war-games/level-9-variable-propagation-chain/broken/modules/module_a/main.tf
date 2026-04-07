module "module_b" {
  source       = "../module_b"
  # BUG: module_b's variable is now named "token_length" but we're passing "string_length" here.
  string_length = var.token_length
}

output "token_result" {
  value = module.module_b.generated_token
}
