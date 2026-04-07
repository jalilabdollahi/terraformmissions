module "mymod" {
  count  = 2
  source = "./modules/datamod"
}

# Wrong: count modules use [0], [1] — not string keys like ["key"]
output "first_file" {
  value = module.mymod["key"].file_path
}
