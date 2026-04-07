module "mods" {
  for_each = toset(["a", "b"])
  source   = "./modules/item"
  label    = each.key
}

# Wrong: module.mods.file_path — for_each modules must be addressed by key.
output "first_file" {
  value = module.mods.file_path
}
