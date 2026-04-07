module "mymod" {
  count  = 2
  source = "./modules/datamod"
}

output "first_file" {
  value = module.mymod[0].file_path
}
