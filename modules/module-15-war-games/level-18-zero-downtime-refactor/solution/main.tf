module "tokens" {
  source = "./modules/tokens"
}

# moved blocks: combined rename + module relocation
moved {
  from = random_string.old_alpha
  to   = module.tokens.random_string.token_alpha
}

moved {
  from = random_string.old_beta
  to   = module.tokens.random_string.token_beta
}

moved {
  from = random_string.old_gamma
  to   = module.tokens.random_string.token_gamma
}

output "all_tokens" {
  value = module.tokens.token_results
}
