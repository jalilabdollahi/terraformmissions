module "mymod" {
  source = "./modules/greeter"
}

output "the_file" {
  value = module.mymod.filename
}
