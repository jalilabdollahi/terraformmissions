# Module was renamed: 'old' -> 'new'. Without a moved block, Terraform
# will destroy module.old and create module.new.
module "new" {
  source = "./modules/datamod"
}
