# These 5 resources were in the root module and have been moved to modules/strings/.
# Missing: moved blocks to tell Terraform the resources relocated.
# Without moved blocks, Terraform plans to destroy originals and recreate inside the module.

module "strings" {
  source = "./modules/strings"
}

output "all_results" {
  value = module.strings.results
}
