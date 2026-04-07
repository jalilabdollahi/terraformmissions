module "mods" {
  for_each = toset(["a", "b"])
  source   = "./modules/item"
  label    = each.key
}

output "first_file" {
  value = module.mods["a"].file_path
}
