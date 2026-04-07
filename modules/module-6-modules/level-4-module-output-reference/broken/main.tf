module "mymod" {
  source = "./modules/hello"
}

# This references a non-existent output 'wrong_output'.
output "result" {
  value = module.mymod.wrong_output
}
