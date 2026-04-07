module "strings" {
  source = "./modules/strings"
}

# moved blocks: tell Terraform the resources relocated from root to the module
moved {
  from = random_string.token_a
  to   = module.strings.random_string.token_a
}

moved {
  from = random_string.token_b
  to   = module.strings.random_string.token_b
}

moved {
  from = random_string.token_c
  to   = module.strings.random_string.token_c
}

moved {
  from = random_string.token_d
  to   = module.strings.random_string.token_d
}

moved {
  from = random_string.token_e
  to   = module.strings.random_string.token_e
}

output "all_results" {
  value = module.strings.results
}
