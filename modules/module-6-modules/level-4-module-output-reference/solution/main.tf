module "mymod" {
  source = "./modules/hello"
}

output "result" {
  value = module.mymod.file_path
}
