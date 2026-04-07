# Full restructure: 3 resources renamed AND moved into a module.
# Old addresses → New addresses:
#   random_string.old_alpha → module.tokens.random_string.token_alpha
#   random_string.old_beta  → module.tokens.random_string.token_beta
#   random_string.old_gamma → module.tokens.random_string.token_gamma
#
# Missing: ALL moved blocks for this combined rename + module relocation.

module "tokens" {
  source = "./modules/tokens"
}

output "all_tokens" {
  value = module.tokens.token_results
}
